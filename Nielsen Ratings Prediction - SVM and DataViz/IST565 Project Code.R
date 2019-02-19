####DATA PREPROCESSING####
#Load packages
library(arules)
library(RWeka)
library(dplyr)
library(ggplot2)
library(e1071)
library(caret)
library(mlbench)
library(FSelector)
library(RColorBrewer)
options(java.parameters = "-Xmx8g")

#Read in dataset
bbt <- read.csv("/Users/coreylucero/Desktop/Syracuse/IST565/IST 565 Project/BigBANG_Sample_Data_promotracking.csv")

#Create function to remove rows that contain NAs in the ActRatings column
reducena <- function(data, desiredcols){
  completevec <- complete.cases(data[, desiredcols])
  return(data[completevec,])
}

#Run Function
reducedbbt <- reducena(bbt, "ActRatings")
View(reducedbbt)

#Convert datatypes
reducedbbt$AirDate <- as.Date(reducedbbt$AirDate, format = "%m/%d/%Y")

#Discretize Ratings
Rating <- discretize(reducedbbt$ActRatings, method = "fixed", 
                                breaks = c(0, .25, .5, .75, Inf), 
                                labels=c(1, 2,3,4))
reducedbbt$Rating <- Rating

####INITIAL ANALYSIS####

#Distribution of ratings
hist(reducedbbt$ActRatings)

ggplot(reducedbbt, aes(x = ActRatings)) + 
  geom_histogram(color="black", "fill"="red" ) + 
  ggtitle("Nielsen Ratings Distribution") +
  geom_vline(aes(xintercept=mean(ActRatings)), color="blue", linetype = "dashed", size=1)
 
sum(reducedbbt$ActRatings>=.5)
quantile(reducedbbt$ActRatings)

#Spots per market (high to low) 
sort(table(reducedbbt$Mkt_Rk), decreasing=T)

#Avg ratings per market (high to low)
sort(tapply(reducedbbt$ActRatings, reducedbbt$Mkt_Rk, mean),decreasing=T)

#Frequency and ratings per day of the week
tapply(reducedbbt$ActRatings,reducedbbt$AirDay, mean)
table(reducedbbt$AirDay)

sapply(reducedbbt, function(x) length(unique(x)))
str(reducedbbt)
#Frequency and ratings per show
sort(table(reducedbbt$AirProgram), decreasing=T)
sort(tapply(reducedbbt$ActRatings, reducedbbt$AirProgram, mean), decreasing=T)

###LOOK FOR WHO GIVES US PAID PROGRAMMING
PaidProgramming <- filter(reducedbbt, reducedbbt$AirProgram == "Paid Program")

PaidProgramming <- reducedbbt %>% 
  count(AirProgram, Mkt_Rk) 

PaidProgramming <- PaidProgramming[215:227,]

PaidProgramming <- PaidProgramming[order(-PaidProgramming$n),]

View(PaidProgramming)

#Build visualizations

####DATA MINING - CLASSIFICATION####

#Remove unneccessary variables
exvars <- names(reducedbbt) %in% c("ActRatings","ActImpression","Agency", "Product", "DEMO", "AirCount", "WeekOf", "DemoOrder")
reducedbbt <- reducedbbt[!exvars]
str(reducedbbt)

exvars2 <- names(reducedbbt) %in% c("AD25_54_RTG_F", "W25_54_RTG_F","EST_IMP_F","RtgSource","GroupOwners","AirDay")

#Create train/test sets
set.seed(10)
n <- round(nrow(reducedbbt)/5)
s <- sample(1:nrow(reducedbbt),n)
bbtTest <- reducedbbt[s,]
bbtTrain <- reducedbbt[-s,]

#Create confusion matrix function
predictfun <- function(x) {
  predicttable <- table(svmbbttest$Rating, x)
  l <- list(predicttable,sum(diag(predicttable)/sum(predicttable)))
  return(l)
}

#Create dataset that removes AirDate 
exvars <- names(bbtTrain) %in% c("AirDate")
exvars2 <- names(bbtTest) %in% c("AirDate")
svmbbt <- bbtTrain[!exvars]
svmbbttest <- bbtTest[!exvars2]

svmbbt <- na.omit(svmbbt)
svmbbttest <- na.omit(svmbbttest)

####MODEL 1 - Decision Tree Model####
WOW("J48")

#Build model
dtt <- J48(Rating ~.,data=bbtTrain, control=Weka_control(C=.25))

#Evaluate model
evaluate_Weka_classifier(dtt, numFolds = 3, seed = 1, class = TRUE)

#default = 68.36%
#C=.3 = 68.36%
#M=3 = 65.49%
#R=TRUE = 66.92%

#Make predictions
dttpred <- predict(dtt, bbtTest, type = c("class"))
predictfun(dttpred)

#default = 71.94%
#It predicts all promos are "poor" ratings. Test data is strongly skewed towards "poor" which is difficult for the model to separate.

####MODEL 2 - Naive Bayes####
WOW("NaiveBayes")
NB <- make_Weka_classifier("weka/classifiers/bayes/NaiveBayes")

#Fit model
nbmodel <- NB(Rating ~ ., data = svmbbt)
nbmodel <- NB(Rating ~ ., data = svmbbt, control=Weka_control(D=TRUE))
nbmodel <- NB(Rating ~ ., data = svmbbt, control=Weka_control(K=TRUE))

#evaluate model
evaluate_Weka_classifier(nbmodel, numFolds = 3, seed = 1, class = TRUE)

#Default = 63.67%
#D=TRUE = 64.45%
#K=TRUE = 63.67%

#Make predictions
p <- predict(nbmodel, bbtTest)
predictfun(p)

#Default = 70.4%
#D=TRUE = 70.4%
#K=TRUE = 70.9%

####MODEL 3 - KNN####
WOW("IBk")

knn <- make_Weka_classifier("weka/classifiers/lazy/IBk")

#build model
knn_model <- knn(Rating ~ ., data=bbtTrain)
knn_model <- knn(Rating ~ ., data=bbtTrain, control=Weka_control(K=2, I=TRUE))
knn_model <- knn(Rating ~ ., data=bbtTrain, control=Weka_control(K=8, I=TRUE))
knn_model <- knn(Rating ~ ., data=bbtTrain, control=Weka_control(K=7, I=TRUE))

#evaluate model
evaluate_Weka_classifier(knn_model, numFolds = 3, seed = 1, class = TRUE)

#default = 70.57%
#K=2, I=True = 69.66%
#K=8 = 72.53%
#K=7 = 73.83%

#Make predictions
p2 <- predict(knn_model, bbtTest)
predictfun(p2)

#K=2 = 77.04%
#K=7 = 80.1%
#K=8 = 80.1%

####MODEL 4 - SVM####

WOW("SMO")
svm <- make_Weka_classifier("weka/classifiers/functions/SMO")
svm_model=svm(Rating~., data=svmbbt)
svm_model=svm(Rating~., data=svmbbt, control=Weka_control(K=list("weka.classifiers.functions.supportVector.PolyKernel", E=4)))
e4 <- evaluate_Weka_classifier(svm_model, numFolds = 3, seed = 1, class = TRUE)
e4

set.seed(1188)
train_control <- trainControl(method="cv", number=3)
fit_svm_linear <- train(Rating~., data=svmbbt, method = 'svmLinear', trControl = train_control, na.action=na.pass)
fit_svm_linear

#default = 73.44%
#PolyKernel, E=2 = 75.52%
#PolyKernel, E=4 = 75.78%

svmmodel1 <- train(Rating~., data = svmbbt, kernel = "radial", gamma = 0.1, cost = 10,na.action=na.exclude)
svmmodel1
p3
length(p3)
#Make predictions
p3 <- predict(svmmodel1, svmbbttest)
predictfun(p3)

svmbbttest2 <- svmbbttest
length(svmbbttest2$Rating)

tuned_parameters <- tune.svm(Rating~., data = svmbbt, gamma = 10^(-2:2), cost = 10^(1:3))
summary(tuned_parameters )
#default = 80.1%
#PolyKernel, E=2 = 81.63%
#PolyKernel, E=4 = 84.18%
#RBFKernel, G=2 = 71.93%

plot(svmmodel1, svmbbt, Day_HH ~ AirTime)

psvm <- data.frame(svmbbt$Rating, svmbbt$AirTime, svmbbt$DAY_HH)

model <- train(svmbbt.Rating ~ svmbbt.AirTime2 + svmbbt.DAY_HH,data=psvm)

Time <- seq(from = min(psvm$svmbbt.DAY_HH), to = max(psvm$svmbbt.DAY_HH), length = 100)
Day <- seq(from = min(psvm$svmbbt.AirTime2),to=max(psvm$svmbbt.AirTime2), length = 100)
x.grid <- expand.grid(Time,Day)

colnames(x.grid) <- c("svmbbt.DAY_HH","svmbbt.AirTime2")

pred <- predict(model, newdata = x.grid)

cols <- brewer.pal(4, "Set1")
plot(x.grid, pch=19, col=adjustcolor(cols[pred], alpha.f = .05))

classes <- matrix(pred, nrow=100, ncol=100)
contour(x=Time, y=Day, z=classes, levels=1:4,labels = "test",add=TRUE)

points(psvm[,3:4], pch=19, col=cols[predict(model)])

psvm$svmbbt.AirTime2 <- format(as.POSIXct(psvm$svmbbt.AirTime), format = "%H:%M:%S %p")
psvm$svmbbt.AirTime2 <- as.numeric(as.POSIXct(psvm$svmbbt.AirTime2))

ggplot(data = psvm, aes(x = svmbbt.DAY_HH, y = svmbbt.AirTime2, color = factor(svmbbt.Rating, labels = c("Poor", "Fair", "Good", "Excellent")), shape = factor(svmbbt.Rating, labels = c("Poor", "Fair", "Good", "Excellent")))) + 
  geom_point(size = 2) +
  scale_color_manual(values=c("#000000", "#FF0000", "#00BA00","#FF9900")) +
  labs(x = "Day", y="Time", color="Rating Quality", shape = "Rating Quality") +
  ggtitle("Promo Rating Quality") +
  theme(plot.title = element_text(hjust=.5))

####MODEL 5 - Random Forest####

WOW("weka/classifiers/trees/RandomForest")
rf <- make_Weka_classifier("weka/classifiers/trees/RandomForest")
rf_model=rf(Rating~., data=bbtTrain, control=Weka_control(I=200))
e5 <- evaluate_Weka_classifier(rf_model, numFolds = 3, seed = 1, class = TRUE)
e5

#200 trees = 80.47%
#100 trees = 72.14%
#50 trees = 72.53%

#Make predictions
p4 <- predict(rf_model, bbtTest)
predictfun(p4)
#80.6% @ 200 trees

####Dimension Reduction####
weights <- gain.ratio(Rating~., svmbbt) #gain ratio
print(weights)
subset <- cutoff.k(weights,2)
f <- as.simple.formula(subset, "Rating")
print(f)

x <- matrix(rnorm(20*2), ncol = 2)
y <- c(rep(-1,10), rep(1,10))
x[y==1,] <- x[y==1,] + 3/2
dat <- data.frame(x=x, y=as.factor(y))

####REFERENCE####
#Try some tapply expressions to see if there are notable differences between values above
tapply(npsDataByHotel$Hotel_NPS, npsDataByHotel$All_Suites_PL, mean)

#Build bar charts of above average/below average hotel NPS scores
npsDataByHotel$NPSisAboveAverage <- npsDataByHotel$Hotel_NPS >= meanNPS  #Add column to the dataframe

#All_Suites_PL stacked bar chart
b2 <- ggplot(npsDataByHotel, aes(x = NPSisAboveAverage, fill = factor(All_Suites_PL))) + geom_bar()
b2 <- b2 + ggtitle("High vs. Low NPS Hotels - All Suites or No?")
b2  #Display the bar chart