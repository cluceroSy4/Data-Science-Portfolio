df <- read.csv("./data/Student+Survey.csv")
dfText <- read.csv("./data/Student+SurveyTEXT..csv", na.strings=c("", "NA", " "))
library(xlsx)
####PREPROCESSING####

#Rename columns
colnames(Cleandf)[1] <- "Age"
colnames(Cleandf)[2] <- "MilitaryStatus"
colnames(Cleandf)[3] <- "StudentStatus"
colnames(Cleandf)[4] <- "State"
colnames(Cleandf)[5] <- "OKCounty"
colnames(Cleandf)[6] <- "Program"
colnames(Cleandf)[7] <- "BeginSchool"
colnames(Cleandf)[8] <- "Competitors"
colnames(Cleandf)[9] <- "CollegeInfo_Family/Friend"
colnames(Cleandf)[10] <- "CollegeInfo_UEmployees"
colnames(Cleandf)[11] <- "CollegeInfo_Email"
colnames(Cleandf)[12] <- "CollegeInfo_Website"
colnames(Cleandf)[13] <- "CollegeInfo_DirectMail"
colnames(Cleandf)[14] <- "CollegeInfo_Google"
colnames(Cleandf)[15] <- "CollegeInfo_Employer"
colnames(Cleandf)[16] <- "CollegeInfo_OtherWebsite"
colnames(Cleandf)[17] <- "CollegeInfo_Other"
colnames(Cleandf)[21] <- "College_Close"
colnames(Cleandf)[22] <- "College_Tuition"
colnames(Cleandf)[23] <- "College_FinancialAid"
colnames(Cleandf)[24] <- "College_CampusCulture"
colnames(Cleandf)[25] <- "College_JobPlacement"
colnames(Cleandf)[26] <- "College_StudentClubs"
colnames(Cleandf)[27] <- "College_SmallClass"
colnames(Cleandf)[28] <- "College_Rural"
colnames(Cleandf)[29] <- "College_ProgramAvailability"
colnames(Cleandf)[30] <- "College_Internships"
colnames(Cleandf)[31] <- "College_CampusFacilities"
colnames(Cleandf)[32] <- "College_AdmissionCompetitiveness"
colnames(Cleandf)[33] <- "College_ProfessorQuality"
colnames(Cleandf)[34] <- "College_UReputation"
colnames(Cleandf)[35] <- "College_EmployerConnections"
colnames(Cleandf)[36] <- "College_AffordableHousing"
colnames(Cleandf)[37] <- "College_MilitaryFriendly"
colnames(Cleandf)[38] <- "Value_DiverseEducation"
colnames(Cleandf)[39] <- "Value_CollegeHelpDefine"
colnames(Cleandf)[40] <- "Value_SocialActivities"
colnames(Cleandf)[41] <- "Value_LifeAfterCollege"
colnames(Cleandf)[42] <- "Value_QuickerTheBetter"
colnames(Cleandf)[43] <- "Value_ValueEmployerConnections"
colnames(Cleandf)[44] <- "Value_DontKnowWant"
colnames(Cleandf)[45] <- "Value_DontCareDegree"
colnames(Cleandf)[46] <- "Value_EmployerRequired"
colnames(Cleandf)[47] <- "WhyProgram"
colnames(Cleandf)[48] <- "Program_Interest"
colnames(Cleandf)[49] <- "Program_FulfillingCareer"
colnames(Cleandf)[50] <- "Program_FurtherEducation"
colnames(Cleandf)[51] <- "Program_HighPay"
colnames(Cleandf)[52] <- "Program_Parents"
colnames(Cleandf)[53] <- "Program_Easy"
colnames(Cleandf)[54] <- "Program_NotFirstChoice"
colnames(Cleandf)[55] <- "Program_FastGrad"
colnames(Cleandf)[56] <- "Program_Employer"
colnames(Cleandf)[57] <- "Program_MilitaryBenefits"
colnames(Cleandf)[58] <- "CultureDescription"
colnames(Cleandf)[59] <- "Media_Broadcast"
colnames(Cleandf)[60] <- "Media_Cable"
colnames(Cleandf)[61] <- "Media_Stream"
colnames(Cleandf)[62] <- "Media_TradRadio"
colnames(Cleandf)[63] <- "Media_OnlineRadio"
colnames(Cleandf)[64] <- "Media_Social"
colnames(Cleandf)[65] <- "Media_Website"
colnames(Cleandf)[66] <- "Media_Apps"
colnames(Cleandf)[67] <- "Media_VideoGames"
colnames(Cleandf)[68] <- "Media_Newspaper"
colnames(Cleandf)[69] <- "Media_Magazine"
colnames(Cleandf)[70] <- "Media_Other"
colnames(Cleandf)[71] <- "Media_OtherText"
colnames(Cleandf)[72] <- "FirstGen"
colnames(Cleandf)[73] <- "Gender"
colnames(Cleandf)[75] <- "Children"
colnames(Cleandf)[76] <- "Employment"
colnames(Cleandf)[77] <- "Education"
colnames(Cleandf)[78] <- "Income"
colnames(Cleandf)[79] <- "MaritalStatus"
colnames(Cleandf)[80] <- "Ethnicity_White"
colnames(Cleandf)[81] <- "Ethnicity_Black"
colnames(Cleandf)[82] <- "Ethnicity_AmericanIndian"
colnames(Cleandf)[83] <- "Ethnicity_Hispanic"
colnames(Cleandf)[84] <- "Ethnicity_Asian"
colnames(Cleandf)[85] <- "Ethnicity_MiddleEastern"
colnames(Cleandf)[86] <- "Ethnicity_Other"
colnames(Cleandf)[87] <- "Ethnicity_OtherText"
colnames(Cleandf)[88] <- "Bilingual"

colnames(CleanTEXT)[6] <- "School" #Text
colnames(CleanTEXT)[88] <- "Bilingual" #Text

#Create datatype conversion function
convert.magic <- function(x, y=NA) {
  for(i in 1:length(y)) { 
    if (y[i] == "n") { 
      x[i] <- as.numeric(x[[i]])
    }
    if (y[i] == "c") {
      x[i] <- as.character(x[[i]])
    }
    if (y[i] == "f") { 
      x[i] <- as.factor(x[[i]])
    }
  }
  return(x)
}

#Change datatypes
#Use datatype conversion function
Cleandf <- convert.magic(Cleandf, c('n',''))

View(Cleandf)
summary(Cleandf)

#Create function to remove rows that contain NAs in the Bilingual column
reducednps <- function(data, desiredcols){
  completevec <- complete.cases(data[, desiredcols])
  return(data[completevec,])
}

#Run Function
Cleandf <- reducednps(Cleandf, "Bilingual") #Remove if didn't complete survey
CleanTEXT <- reducednps(CleanTEXT, "Bilingual") #Text

#Append school text vector to main df
Cleandf$ProgramText <- CleanTEXT$School

#Group programs into school variable

Cleandf$School <- cut(Cleandf$Program, breaks=c(0, 9, 15, 19, 20, 25, 28, 39, 45, 48, 51, 54), 
                      labels=c("Arts & Sciences", "Automotive Technologies", "Construction Technologies", "Culinary Arts", "Diesel & Heavy Equipment", "Energy Technologies","Engineering Technologies","Information Technologies","Nursing & Health Sciences","Visual Communications","Undecided/NonDegree/Other"))

####CLUSTER ANALYSIS####

#Elbow Method for finding the optimal number of clusters
set.seed(123)
# Compute and plot wss for k = 2 to k = 15.
k.max <- 15 #Set max number of clusters
data <- Cleandf[,38:46]
data = as.data.frame(unclass(data)) #Remove NAs
data = na.omit(data)
summary(data) #Confirm there is no NAs
wss <- sapply(2:k.max, 
              function(k){kmeans(data, k, nstart=50,iter.max = 15 )$tot.withinss}) #Calculate clusters and store within-sum of squares
wss

bss <- sapply(2:k.max, 
              function(k){kmeans(data, k, nstart=50,iter.max = 15 )$betweenss}) #Calculate clusters and store between-sum of squares
bss
rss <- wss/bss #Calculate ratio

plot(2:k.max, rss,
     type="b", pch = 19, frame = FALSE, 
     xlab="Number of clusters K",
     ylab="Ratio of within/between sum of squares") #Create elbow plot

#Doesn't result in a clear "elbow", need to remove questions that don't discriminate between clusters

boxplot(data$Value_DiverseEducation, data$Value_CollegeHelpDefine, data$Value_SocialActivities, data$Value_LifeAfterCollege, data$Value_QuickerTheBetter, data$Value_ValueEmployerConnections, data$Value_DontKnowWant, data$Value_DontCareDegree, data$Value_EmployerRequired)
#Boxplot to compare variance

sapply(1:9,
       function(k){var(data[k])}) #Compute variance for each column
View(data)
datareduced <- data[,-c(5:6)] #Quicker the Better and Employer Connections has lowest variance so it was removed
View(datareduced)

#Recalculate clusters wss, bss and rss
rwss <- sapply(2:k.max, 
               function(k){kmeans(datareduced, k, nstart=50,iter.max = 15 )$tot.withinss})
rbss <- sapply(2:k.max, 
               function(k){kmeans(datareduced, k, nstart=50,iter.max = 15 )$betweenss})
rrss <- rwss/rbss #reduced rss

plot(2:k.max, rrss,
     type="b", pch = 19, frame = FALSE, 
     xlab="Number of clusters K",
     ylab="Ratio of within/between sum of squares")

#Run kmeans algorithm at k=4
dfClusters <- kmeans(data, 4, nstart=50,iter.max = 15 )
dfClusters

#Append the cluster assignment to the original dataset
Cleandf <- data.frame(Cleandf, dfClusters$cluster)

colnames(Cleandf)[90] <- "Cluster"

write.xlsx(Cleandf, "/Users/coreylucero/Desktop/SG R Projects/OSUIT/dfOSUIT.xlsx")

#Create dataset with k=3
dfClusters2 <- kmeans(data, 3, nstart=50,iter.max = 15 )
dfClusters2

df3Clusters <- Cleandf #Copy dataset to new dataframe

#Append the cluster assignment to the new dataframe
df3Clusters <- data.frame(df3Clusters, dfClusters2$cluster)

df3Clusters <- df3Clusters[,-90] #Remove k=4 cluster column

colnames(df3Clusters)[92] <- "Cluster" #Rename new k=3 cluster column

write.xlsx(df3Clusters, "/Users/coreylucero/Desktop/SG R Projects/OSUIT/df3Clusters.xlsx")

####PROFILE ANALYSIS####

hist(Cleandf$Cluster)

#Important college factors by cluster
tapply(Cleandf$College_Close, Cleandf$Cluster, mean)  #Close to home 
tapply(Cleandf$College_Tuition, Cleandf$Cluster, mean)  #Tuition cost
tapply(Cleandf$College_FinancialAid, Cleandf$Cluster, mean)  #Financial aid
tapply(Cleandf$College_CampusCulture, Cleandf$Cluster, mean)  #Campus culture
tapply(Cleandf$College_JobPlacement, Cleandf$Cluster, mean)  #Job placement rate
tapply(Cleandf$College_StudentClubs , Cleandf$Cluster, mean)  #Student clubs
tapply(Cleandf$College_SmallClass, Cleandf$Cluster, mean)  #Small classes
tapply(Cleandf$College_Rural, Cleandf$Cluster, mean)  #Rural community
tapply(Cleandf$College_ProgramAvailability, Cleandf$Cluster, mean)  #Availability of specific program
tapply(Cleandf$College_Internships, Cleandf$Cluster, mean)  #Internships and hands-on opportunities
tapply(Cleandf$College_CampusFacilities, Cleandf$Cluster, mean)  #Campus facilities
tapply(Cleandf$College_AdmissionCompetitiveness, Cleandf$Cluster, mean)  #Admissions criteria
tapply(Cleandf$College_ProfessorQuality, Cleandf$Cluster, mean)  #Expertise of professors
tapply(Cleandf$College_UReputation, Cleandf$Cluster, mean)  #University reputation
tapply(Cleandf$College_EmployerConnections, Cleandf$Cluster, mean)  #Employer connections

#Important program factors by cluster
tapply(Cleandf$Program_Easy, Cleandf$Cluster, mean)  #Easy requirements
tapply(Cleandf$Program_Employer, Cleandf$Cluster, mean)  #Employer Encouraged
tapply(Cleandf$Program_Interest, Cleandf$Cluster, mean)  #Interest in subject
tapply(Cleandf$Program_FulfillingCareer, Cleandf$Cluster, mean)  #Fulfilling career
tapply(Cleandf$Program_FurtherEducation, Cleandf$Cluster, mean)  #Further education
tapply(Cleandf$Program_HighPay, Cleandf$Cluster, mean)  #High pay
tapply(Cleandf$Program_Parents, Cleandf$Cluster, mean)  #Parents Encouraged
tapply(Cleandf$Program_FastGrad, Cleandf$Cluster, mean)  #Fast Grad
tapply(Cleandf$Program_NotFirstChoice, Cleandf$Cluster, mean)  #Not First Choice

Cleandf$Gender
CleanTEXT$Are.you....Selected.Choice

Cleandf$Children
CleanTEXT$Which.of.the.following.best.describes.you.

####Culture Text Cloud####
library(tm)
library(wordcloud)

df_Stopwords <- c("school", "want", "wanted","osuit","chose","program","degree","things")

#Create Word Cloud function
GenerateWordCloud <- function(x)
{
  y <- Corpus(VectorSource(x))
  #Make all letters lowercase
  y <- tm_map(y, content_transformer(tolower))
  #Remove punctuation
  y <- tm_map(y, removePunctuation)
  #Remove numbers
  y <- tm_map(y, removeNumbers)
  #Take out "stop" words
  y <- tm_map(y, removeWords, stopwords("english"))
  y <- tm_map(y, removeWords, df_Stopwords)
  
  #Create document matrix 
  tdm1 <- TermDocumentMatrix(y)
  m1 <- as.matrix(tdm1)
  wordCounts1 <- rowSums(m1)
  totalwords1 <- sum(wordCounts1)
  words1 <- names(wordCounts1)
  cloudFrame1 <- data.frame(word=names(wordCounts1), freq=wordCounts1)
  wordcloud(names(wordCounts1),wordCounts1, scale=c(5,.4), rot.per=.15, random.order=FALSE, min.freq=2,colors=brewer.pal(5,"Dark2"))
}

#Create word cloud
GenerateWordCloud(Cleandf$CultureDescription)
GenerateWordCloud(Cleandf$Whydf)
GenerateWordCloud(Cleandf$WhyProgram)




