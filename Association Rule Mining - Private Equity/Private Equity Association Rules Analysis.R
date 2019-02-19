#Load packages
library(plyr)
library(dplyr)
library(arules)
library(arulesViz)

#Read in data
bd <- read.csv("/Users/coreylucero/Desktop/Syracuse/IST565/Week 3 - Association Rule Mining/bankdata_csv_all.csv")
View(bd)
str(bd)
summary(bd)
#DATA TRANSFORMATION

#Remove ID field
bd$id <- NULL

#Minimum age is 18
min(bd$age)

#Discretize age by custom bins
bd$age <- cut(bd$age, breaks = c(18,25,35,45,55,65,Inf),labels=c("18-24","25-34","35-44","45-54","55-65","65+"))

#Convert children variable to factor
bd$children <- factor(bd$children)

#Disretize income by equal-width bins
min_income <- min(bd$income)
max_income <- max(bd$income)
bins <- 6
width <- (max_income - min_income)/bins
bd$income <- cut(bd$income, breaks=seq(min_income, max_income, width))

#Tried 3 to 5 bins then 6 bins

#Load dataset into apriori algorithm
ARMRules <- apriori(bd, parameter=list(supp=.001, conf=.9, maxlen=3))

#Set options to 2 digits to make support/confidence/lift easier to read
options(digits=2)

#Sort by confidence to view strongest rules first
ARMRules <- sort(ARMRules, by="confidence", decreasing=TRUE)

inspect(ARMRules[1:30])

subruleslift <- head(sort(ARMRules, by="lift"), 30)
inspect(subruleslift)

plot(ARMRules)

#Set rhs to PEP
PEPRules <- apriori(bd, parameter=list(supp=.001, conf=.8, maxlen=3), appearance=list(default="lhs",rhs="pep=YES"))
subruleslift2 <- head(sort(PEPRules, by="lift"), 50)
inspect(subruleslift2)

#Plot the rules
plot(subruleslift2)
