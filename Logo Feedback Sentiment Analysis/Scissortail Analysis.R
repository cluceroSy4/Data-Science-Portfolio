#Load in packages and files - survey responses and text list
library(readxl)
Scissortail_Park_Logo_Testing_April <- read_excel("/Users/coreylucero/Desktop/SG R Projects/Scissortail/Scissortail_Park_Logo_Testing_April.xlsx")
CleanSurveyData <- Scissortail_Park_Logo_Testing_April[-c(3:5, 6,7,9:12,15:17)] 
CleanSurveyData <- Scissortail_Park_Logo_Testing_April[-c(3:5)] 
CleanSurveyData <- CleanSurveyData[-c(4:5)]
CleanSurveyData <- CleanSurveyData[-c(5:8)]
CleanSurveyData <- CleanSurveyData[-c(7:9)] 
View(CleanSurveyData)
View(Scissortail_Park_Logo_Testing_April)


library(tm)
library(wordcloud)
library(maps)
library(mapproj)
library(ggmap)
library(ggplot2)
library(zipcode)
library(gmodels)
install.packages("gplot")

AFINN <- read.delim("~/Desktop/SG R Projects/AFINN_List.txt", sep="\t", header=FALSE)
colnames(AFINN) <- c("word", "Score")

#Custom stop words for wordcloud
Scissortail_Stopwords <- c("think","bird","see","doesnâ€™it","â€™m","thereâ€™s","fucking","â€œbirdâ€","just", "represent", "represents", "says", "itâ€™s", "didnâ€™t", "maybe", "like", "looks", "park", "dont", "logo", "nothing", "donâ€™t", "much", "can", "doesnt", "sure")

#Clean survey responses

#Rename columns
colnames(CleanSurveyData)[8] <- "zip"
colnames(CleanSurveyData)[9] <- "Age"
colnames(CleanSurveyData)[10] <- "Gender"
colnames(CleanSurveyData)[11] <- "Children"
colnames(CleanSurveyData)[12] <- "Married"
colnames(CleanSurveyData)[13] <- "Ethnicity"
colnames(CleanSurveyData)[14] <- "Income"
colnames(CleanSurveyData)[15] <- "Education"

colnames(CleanSurveyData)[16] <- "Reaction1.1"
colnames(CleanSurveyData)[17] <- "Describe1.2"
colnames(CleanSurveyData)[18] <- "PercPark1.3"
colnames(CleanSurveyData)[19] <- "Welcoming1"
colnames(CleanSurveyData)[20] <- "Fun1"
colnames(CleanSurveyData)[21] <- "Beautiful1"

colnames(CleanSurveyData)[22] <- "Reaction2.1"
colnames(CleanSurveyData)[23] <- "Describe2.2"
colnames(CleanSurveyData)[24] <- "PercPark2.3"
colnames(CleanSurveyData)[25] <- "Welcoming2"
colnames(CleanSurveyData)[26] <- "Fun2"
colnames(CleanSurveyData)[27] <- "Beautiful2"

colnames(CleanSurveyData)[28] <- "Reaction3.1"
colnames(CleanSurveyData)[29] <- "Describe3.2"
colnames(CleanSurveyData)[30] <- "PercPark3.3"
colnames(CleanSurveyData)[31] <- "Welcoming3"
colnames(CleanSurveyData)[32] <- "Fun3"
colnames(CleanSurveyData)[33] <- "Beautiful3"

colnames(CleanSurveyData)[34] <- "Reaction4.1"
colnames(CleanSurveyData)[35] <- "Describe4.2"
colnames(CleanSurveyData)[36] <- "PercPark4.3"
colnames(CleanSurveyData)[37] <- "Welcoming4"
colnames(CleanSurveyData)[38] <- "Fun4"
colnames(CleanSurveyData)[39] <- "Beautiful4"

colnames(CleanSurveyData)[40] <- "Reaction5.1"
colnames(CleanSurveyData)[41] <- "Describe5.2"
colnames(CleanSurveyData)[42] <- "PercPark5.3"
colnames(CleanSurveyData)[43] <- "Welcoming5"
colnames(CleanSurveyData)[44] <- "Fun5"
colnames(CleanSurveyData)[45] <- "Beautiful5"

CleanSurveyData <- CleanSurveyData[-c(1,2),]

#Group Zipcodes by Region
Region <- "START"
for(i in 1:359)
{
if((CleanSurveyData$zip[i] == 73105) | (CleanSurveyData$zip[i] == 73111) | (CleanSurveyData$zip[i] == 73131) | (CleanSurveyData$zip[i] == 73117) | (CleanSurveyData$zip[i] == 73121) | (CleanSurveyData$zip[i] == 73151) | (CleanSurveyData$zip[i] == 73141) | (CleanSurveyData$zip[i] == 73130) | (CleanSurveyData$zip[i] == 73110)) {
    Region <- c(Region, "Northeast")
  } else if((CleanSurveyData$zip[i] == 73142) | (CleanSurveyData$zip[i] == 73134) | (CleanSurveyData$zip[i] == 73120) | (CleanSurveyData$zip[i] == 73114) | (CleanSurveyData$zip[i] == 73116) | (CleanSurveyData$zip[i] == 73162) | (CleanSurveyData$zip[i] == 73132) | (CleanSurveyData$zip[i] == 73127) | (CleanSurveyData$zip[i] == 73107) | (CleanSurveyData$zip[i] == 73112) | (CleanSurveyData$zip[i] == 73118) | (CleanSurveyData$zip[i] == 73008) | (CleanSurveyData$zip[i] == 73122)) {
      Region <- c(Region, "Northwest")
  } else if((CleanSurveyData$zip[i] == 73106) | (CleanSurveyData$zip[i] == 73102) | (CleanSurveyData$zip[i] == 73103) | (CleanSurveyData$zip[i] == 73104)) {
        Region <- c(Region, "Central")
     } else if((CleanSurveyData$zip[i] == 73109) | (CleanSurveyData$zip[i] == 73108) | (CleanSurveyData$zip[i] == 73119) | (CleanSurveyData$zip[i] == 73139) | (CleanSurveyData$zip[i] == 73159) | (CleanSurveyData$zip[i] == 73179) | (CleanSurveyData$zip[i] == 73170) | (CleanSurveyData$zip[i] == 73173) | (CleanSurveyData$zip[i] == 73169)) {
          Region <- c(Region, "Southwest")
       } else if((CleanSurveyData$zip[i] == 73129) | (CleanSurveyData$zip[i] == 73149) | (CleanSurveyData$zip[i] == 73160) | (CleanSurveyData$zip[i] == 73165) | (CleanSurveyData$zip[i] == 73115) | (CleanSurveyData$zip[i] == 73145) | (CleanSurveyData$zip[i] == 73135) | (CleanSurveyData$zip[i] == 73150)) {
            Region <- c(Region, "Southeast")
         } else {
            Region <- c(Region, "Other")
         }
}
      
Region <- Region[-1]

CleanSurveyData$Region <- Region

#Create datatype conversion function
convert.magic <- function(x, y=NA) {
  for(i in 1:length(y)) { 
    if (y[i] == "numeric") { 
      x[i] <- as.numeric(x[[i]])
    }
    if (y[i] == "character") {
      x[i] <- as.character(x[[i]])
    }
      if (y[i] == "factor") { 
        x[i] <- as.factor(x[[i]])
      }
  }
  return(x)
}

#Use datatype conversion function
CleanSurveyData <- convert.magic(CleanSurveyData, c('character', 'character', 'character', 'factor', 'factor', 'factor', 'factor','factor','factor','factor','factor','factor','factor','factor','factor','character', 'character', 'character','factor','factor','factor','character', 'character', 'character','factor','factor','factor','character', 'character', 'character','factor','factor','factor','character', 'character', 'character','factor','factor','factor','character', 'character', 'character','factor','factor','factor','factor','character','character','character','character','character','factor','character','character','character','character','character','character','character','character','character','character','character','character','character','character','character','character','factor','factor'))

#Remove additional unneccessary rows
CleanSurveyData <- CleanSurveyData[-c(54:69)]

summary(CleanSurveyData)


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
  y <- tm_map(y, removeWords, Scissortail_Stopwords)
  
  #Create document matrix 
  tdm1 <- TermDocumentMatrix(y)
  m1 <- as.matrix(tdm1)
  wordCounts1 <- rowSums(m1)
  totalwords1 <- sum(wordCounts1)
  words1 <- names(wordCounts1)
  cloudFrame1 <- data.frame(word=names(wordCounts1), freq=wordCounts1)
  wordcloud(names(wordCounts1),wordCounts1, scale=c(4,.2), rot.per=.15, random.order=FALSE, min.freq=1,colors=brewer.pal(5,"Dark2"))
}

#Create Sentiment percentage function
SentimentFunction <- function(x)
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
  
  #Create document matrix 
  tdm1 <- TermDocumentMatrix(y)
  m1 <- as.matrix(tdm1)
  wordCounts1 <- rowSums(m1)
  totalwords1 <- sum(wordCounts1)
  words1 <- names(wordCounts1)
  cloudFrame <- data.frame(word=names(wordCounts1), freq=wordCounts1)
  mergedTable <- merge(cloudFrame, AFINN, by.x="word", by.y="word")
  overallscore <- sum(mergedTable$freq * mergedTable$Score)
  sentiment <- overallscore/totalwords1
  print(sentiment)
}


#Create Sentiment score function
SentimentScore <- function(x)
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
  
  #Create document matrix 
  tdm1 <- TermDocumentMatrix(y)
  m1 <- as.matrix(tdm1)
  wordCounts1 <- rowSums(m1)
  totalwords1 <- sum(wordCounts1)
  words1 <- names(wordCounts1)
  cloudFrame <- data.frame(word=names(wordCounts1), freq=wordCounts1)
  mergedTable <- merge(cloudFrame, AFINN, by.x="word", by.y="word")
  overallscore <- sum(mergedTable$freq * mergedTable$Score)
  print(overallscore)
}

#Create word clouds

GenerateWordCloud(CleanSurveyData$Reaction1.1)
GenerateWordCloud(CleanSurveyData$Describe1.2)
GenerateWordCloud(CleanSurveyData$PercPark1.3)

GenerateWordCloud(CleanSurveyData$Reaction2.1)
GenerateWordCloud(CleanSurveyData$Describe2.2)
GenerateWordCloud(CleanSurveyData$PercPark2.3)

GenerateWordCloud(CleanSurveyData$Reaction3.1)
GenerateWordCloud(CleanSurveyData$Describe3.2)
GenerateWordCloud(CleanSurveyData$PercPark3.3)

GenerateWordCloud(CleanSurveyData$Reaction4.1)
GenerateWordCloud(CleanSurveyData$Describe4.2)
GenerateWordCloud(CleanSurveyData$PercPark4.3)

GenerateWordCloud(CleanSurveyData$Reaction5.1)
GenerateWordCloud(CleanSurveyData$Describe5.2)
GenerateWordCloud(CleanSurveyData$PercPark5.3)

#Sentiment percentage analysis
SentimentFunction(CleanSurveyData$Reaction1.1)
SentimentFunction(CleanSurveyData$Describe1.2)
SentimentFunction(CleanSurveyData$PercPark1.3)

SentimentFunction(CleanSurveyData$Reaction2.1)
SentimentFunction(CleanSurveyData$Describe2.2)
SentimentFunction(CleanSurveyData$PercPark2.3)

SentimentFunction(CleanSurveyData$Reaction3.1)
SentimentFunction(CleanSurveyData$Describe3.2)
SentimentFunction(CleanSurveyData$PercPark3.3)

SentimentFunction(CleanSurveyData$Reaction4.1)
SentimentFunction(CleanSurveyData$Describe4.2)
SentimentFunction(CleanSurveyData$PercPark4.3)

SentimentFunction(CleanSurveyData$Reaction5.1)
SentimentFunction(CleanSurveyData$Describe5.2)
SentimentFunction(CleanSurveyData$PercPark5.3)

#Sentiment scores
SentimentScore(CleanSurveyData$Reaction1.1)
SentimentScore(CleanSurveyData$Describe1.2)
SentimentScore(CleanSurveyData$PercPark1.3)

SentimentScore(CleanSurveyData$Reaction2.1)
SentimentScore(CleanSurveyData$Describe2.2)
SentimentScore(CleanSurveyData$PercPark2.3)

SentimentScore(CleanSurveyData$Reaction3.1)
SentimentScore(CleanSurveyData$Describe3.2)
SentimentScore(CleanSurveyData$PercPark3.3)

SentimentScore(CleanSurveyData$Reaction4.1)
SentimentScore(CleanSurveyData$Describe4.2)
SentimentScore(CleanSurveyData$PercPark4.3)

SentimentScore(CleanSurveyData$Reaction5.1)
SentimentScore(CleanSurveyData$Describe5.2)
SentimentScore(CleanSurveyData$PercPark5.3)

#Compare Gender reactions to logo 1
SentimentFunction(subset(CleanSurveyData, Gender=="1", select=c(Reaction1.1)))
SentimentFunction(subset(CleanSurveyData, Gender=="2", select=c(Reaction1.1)))

#Compare Gender reactions to logo 2
SentimentFunction(subset(CleanSurveyData, Gender=="1", select=c(Reaction2.1)))
SentimentFunction(subset(CleanSurveyData, Gender=="2", select=c(Reaction2.1)))

#Compare Gender reactions to logo 3
SentimentFunction(subset(CleanSurveyData, Gender=="1", select=c(Reaction3.1)))
SentimentFunction(subset(CleanSurveyData, Gender=="2", select=c(Reaction3.1)))

#Compare Gender reactions to logo 4
SentimentFunction(subset(CleanSurveyData, Gender=="1", select=c(Reaction4.1)))
SentimentFunction(subset(CleanSurveyData, Gender=="2", select=c(Reaction4.1)))

#Compare Gender reactions to logo 5
SentimentFunction(subset(CleanSurveyData, Gender=="1", select=c(Reaction5.1)))
SentimentFunction(subset(CleanSurveyData, Gender=="2", select=c(Reaction5.1)))

#Men prefer logo 4 (1.36), logo 2 (.74), logo 3 (.70)
#Women have fairly equal sentiment across all logos (.43 - .46) but dislike logo 2 (.33)


#Compare Income reactions to logo 1
SentimentFunction(subset(CleanSurveyData, Income=="1", select=c(Reaction1.1)))
SentimentFunction(subset(CleanSurveyData, Income=="2", select=c(Reaction1.1)))
SentimentFunction(subset(CleanSurveyData, Income=="3", select=c(Reaction1.1)))
SentimentFunction(subset(CleanSurveyData, Income=="4", select=c(Reaction1.1)))
SentimentFunction(subset(CleanSurveyData, Income=="5", select=c(Reaction1.1)))
SentimentFunction(subset(CleanSurveyData, Income=="6", select=c(Reaction1.1)))

#Compare Income reactions to logo 2
SentimentFunction(subset(CleanSurveyData, Income=="1", select=c(Reaction2.1)))
SentimentFunction(subset(CleanSurveyData, Income=="2", select=c(Reaction2.1)))
SentimentFunction(subset(CleanSurveyData, Income=="3", select=c(Reaction2.1)))
SentimentFunction(subset(CleanSurveyData, Income=="4", select=c(Reaction2.1)))
SentimentFunction(subset(CleanSurveyData, Income=="5", select=c(Reaction2.1)))
SentimentFunction(subset(CleanSurveyData, Income=="6", select=c(Reaction2.1)))

#Compare Income reactions to logo 3
SentimentFunction(subset(CleanSurveyData, Income=="1", select=c(Reaction3.1)))
SentimentFunction(subset(CleanSurveyData, Income=="2", select=c(Reaction3.1)))
SentimentFunction(subset(CleanSurveyData, Income=="3", select=c(Reaction3.1)))
SentimentFunction(subset(CleanSurveyData, Income=="4", select=c(Reaction3.1)))
SentimentFunction(subset(CleanSurveyData, Income=="5", select=c(Reaction3.1)))
SentimentFunction(subset(CleanSurveyData, Income=="6", select=c(Reaction3.1)))

#Compare Income reactions to logo 4
SentimentFunction(subset(CleanSurveyData, Income=="1", select=c(Reaction4.1)))
SentimentFunction(subset(CleanSurveyData, Income=="2", select=c(Reaction4.1)))
SentimentFunction(subset(CleanSurveyData, Income=="3", select=c(Reaction4.1)))
SentimentFunction(subset(CleanSurveyData, Income=="4", select=c(Reaction4.1)))
SentimentFunction(subset(CleanSurveyData, Income=="5", select=c(Reaction4.1)))
SentimentFunction(subset(CleanSurveyData, Income=="6", select=c(Reaction4.1)))

#Compare Income reactions to logo 5
SentimentFunction(subset(CleanSurveyData, Income=="1", select=c(Reaction5.1)))
SentimentFunction(subset(CleanSurveyData, Income=="2", select=c(Reaction5.1)))
SentimentFunction(subset(CleanSurveyData, Income=="3", select=c(Reaction5.1)))
SentimentFunction(subset(CleanSurveyData, Income=="4", select=c(Reaction5.1)))
SentimentFunction(subset(CleanSurveyData, Income=="5", select=c(Reaction5.1)))
SentimentFunction(subset(CleanSurveyData, Income=="6", select=c(Reaction5.1)))



#Compare Age 18-24 reactions 
SentimentFunction(subset(CleanSurveyData, Age=="2", select=c(Reaction1.1)))
SentimentFunction(subset(CleanSurveyData, Age=="2", select=c(Reaction2.1)))
SentimentFunction(subset(CleanSurveyData, Age=="2", select=c(Reaction3.1)))
SentimentFunction(subset(CleanSurveyData, Age=="2", select=c(Reaction4.1)))
SentimentFunction(subset(CleanSurveyData, Age=="2", select=c(Reaction5.1)))

#Compare Age 25-34 reactions 
SentimentFunction(subset(CleanSurveyData, Age=="3", select=c(Reaction1.1)))
SentimentFunction(subset(CleanSurveyData, Age=="3", select=c(Reaction2.1)))
SentimentFunction(subset(CleanSurveyData, Age=="3", select=c(Reaction3.1)))
SentimentFunction(subset(CleanSurveyData, Age=="3", select=c(Reaction4.1)))
SentimentFunction(subset(CleanSurveyData, Age=="3", select=c(Reaction5.1)))

#Compare Age 35-44 reactions 
SentimentFunction(subset(CleanSurveyData, Age=="4", select=c(Reaction1.1)))
SentimentFunction(subset(CleanSurveyData, Age=="4", select=c(Reaction2.1)))
SentimentFunction(subset(CleanSurveyData, Age=="4", select=c(Reaction3.1)))
SentimentFunction(subset(CleanSurveyData, Age=="4", select=c(Reaction4.1)))
SentimentFunction(subset(CleanSurveyData, Age=="4", select=c(Reaction5.1)))

#Compare Age 45-54 reactions 
SentimentFunction(subset(CleanSurveyData, Age=="5", select=c(Reaction1.1)))
SentimentFunction(subset(CleanSurveyData, Age=="5", select=c(Reaction2.1)))
SentimentFunction(subset(CleanSurveyData, Age=="5", select=c(Reaction3.1)))
SentimentFunction(subset(CleanSurveyData, Age=="5", select=c(Reaction4.1)))
SentimentFunction(subset(CleanSurveyData, Age=="5", select=c(Reaction5.1)))

#Compare Age 55-64 reactions 
SentimentFunction(subset(CleanSurveyData, Age=="6", select=c(Reaction1.1)))
SentimentFunction(subset(CleanSurveyData, Age=="6", select=c(Reaction2.1)))
SentimentFunction(subset(CleanSurveyData, Age=="6", select=c(Reaction3.1)))
SentimentFunction(subset(CleanSurveyData, Age=="6", select=c(Reaction4.1)))
SentimentFunction(subset(CleanSurveyData, Age=="6", select=c(Reaction5.1)))

#Compare Age 65-74 reactions 
SentimentFunction(subset(CleanSurveyData, Age=="7", select=c(Reaction1.1)))
SentimentFunction(subset(CleanSurveyData, Age=="7", select=c(Reaction2.1)))
SentimentFunction(subset(CleanSurveyData, Age=="7", select=c(Reaction3.1)))
SentimentFunction(subset(CleanSurveyData, Age=="7", select=c(Reaction4.1)))
SentimentFunction(subset(CleanSurveyData, Age=="7", select=c(Reaction5.1)))

#Compare Age 75+ reactions 
SentimentFunction(subset(CleanSurveyData, Age=="8", select=c(Reaction1.1)))
SentimentFunction(subset(CleanSurveyData, Age=="8", select=c(Reaction2.1)))
SentimentFunction(subset(CleanSurveyData, Age=="8", select=c(Reaction3.1)))
SentimentFunction(subset(CleanSurveyData, Age=="8", select=c(Reaction4.1)))
SentimentFunction(subset(CleanSurveyData, Age=="8", select=c(Reaction5.1)))


summary(CleanSurveyData)


CrossTable(CleanSurveyData$Income, CleanSurveyData$Q56)

#Gender Favorites
GenderFav <- data.frame(Favorite=CleanSurveyData$Q56, Gender=CleanSurveyData$Gender)
table(GenderFav)
