#Load in all data
npsdata <- get(load("/Users/coreylucero/Desktop/Syracuse/IST 687/Project Assets/nps_subset.RData"))

library(ggplot2)
library(RCurl)
library(jsonlite)
library(RJSONIO)
library(maps)
library(mapproj)
library(kernlab)
install.packages("kernlab")

####CLEAN DATA####

#Create function to remove rows that contain NAs in the Likelihood to Recommend column
reducednps <- function(data, desiredcols){
  completevec <- complete.cases(data[, desiredcols])
  return(data[completevec,])
}

#Run Function
npsdata <- reducednps(npsdata, "Likelihood_Recommend_H")

#Remove spaces from names
names(npsdata) <- gsub(" ","_",names(npsdata))

#Rename hotel name columns
colnames(npsdata)[59] <- "FB_FREQ_H"
colnames(npsdata)[60] <- "FB_Overall_Experience_H"
colnames(npsdata)[64] <- "Hotel_Name_Long_PL"
colnames(npsdata)[65] <- "Hotel_Name_Short_PL"
colnames(npsdata)[94] <- "Dry_Cleaning_PL"
colnames(npsdata)[102] <- "MiniBar_PL"
colnames(npsdata)[103] <- "Pool_Indoor_PL"
colnames(npsdata)[104] <- "Pool_Outdoor_PL"
colnames(npsdata)[108] <- "Self_Parking_PL"
colnames(npsdata)[114] <- "Spa_FB_offering_PL"

#Remove large dataset from workspace
rm(DT_exp_final_set)

#Create function to combine duplicate columns
combineVectors <- function(x, y)
{
  if(length(x) != length(y)) print("Vector lengths not equal")
  else
  {
    newVec <- x
    for(i in 1:length(x))
    {
      if(is.na(x[i]))
        newVec[i] <- y[i]
      else
      {
        if(is.na(y[i]))
          newVec[i] <- x[i]
        else
        {
          if(x[i] != y[i])
            newVec[i] <- "UNEQUAL"
        }
      }
    }
    return(newVec)
  }
}

#Combine duplicate columns
npsdata$Length_Of_Stay <- combineVectors(npsdata$Length_Stay_H, npsdata$LENGTH_OF_STAY_C)  #987 are unequal
npsdata$Guest_State <- combineVectors(npsdata$Guest_State_H, npsdata$STATE_R) #25,279 are unequal
#Person who made reservation is in different state from guest staying
npsdata$Guest_Gender <- combineVectors(npsdata$Gender_H, npsdata$e_hy_gss_gender_I) #ALL but 359 are unequal
npsdata$GP_Tier_Combined <- combineVectors(npsdata$GP_Tier_H, npsdata$e_hy_gss_tier_I) #22 are unequal
npsdata$Checkout_Date <- combineVectors(npsdata$Guest_Checkout_Date_H, npsdata$DEPARTURE_DATE_R) #19,988 are unequal

#Create data frame of survey results compiled by hotel
uniqueHotelIDs <- unique(npsdata$Property_ID_PL)  #Vector of unique hotel identifiers

NPSvector <- 0  #Placeholder to start NPS vector
for(i in 1:396)  #Loop to build vector of hotel NPS values
{
  placeholderData <- data.frame(npsdata$Property_ID_PL, npsdata$NPS_Type)
  colnames(placeholderData) <- c("Property_ID", "NPS_Type")
  placeholderData <- placeholderData[placeholderData$Property_ID == uniqueHotelIDs[i],]
  numPromoters <- length(placeholderData$NPS_Type[placeholderData$NPS_Type == "Promoter"])
  numPassives <- length(placeholderData$NPS_Type[placeholderData$NPS_Type == "Passive"])
  numDetractors <- length(placeholderData$NPS_Type[placeholderData$NPS_Type == "Detractor"])
  percPromoters <- (numPromoters / (numPromoters + numPassives + numDetractors)) * 100
  percDetractors <- (numDetractors / (numPromoters + numPassives + numDetractors)) * 100
  NPSmeasure <- percPromoters - percDetractors
  NPSvector <- c(NPSvector, NPSmeasure)
}
NPSvector <- NPSvector[-1]  #Remove the initial 0 starting the vector

npsDataByHotel <- npsdata[, c(63:64, 67:71, 75:76, 79, 87:115)]  #Create new dataframe with only data useful at hotel level
npsDataByHotel <- npsDataByHotel[!duplicated(npsDataByHotel),]  #Remove duplicate columns
npsDataByHotel$Hotel_NPS <- NPSvector  #Append dataframe with hotel NPS values

#Reset row numbers
rownames(npsDataByHotel) <- NULL

#WARNING: Next chunk of code takes a good 10 minutes or so to run!!
for(i in 51:60)  #Loop to build out 10 new columns of average survey values at hotel level
{
  avgVec <- 0
  for(j in 1:396)
  {
    placeholderData <- data.frame(npsdata$Property_ID_PL, npsdata[, i])
    placeholderData <- na.omit(placeholderData)
    placeholderData <- placeholderData[placeholderData[, 1] == uniqueHotelIDs[j],]
    avgOfColumn <- mean(placeholderData[, 2])
    avgVec <- c(avgVec, avgOfColumn)
  }
  avgVec <- avgVec[-1]
  npsDataByHotel <- cbind(npsDataByHotel, avgVec)
}

#Build column of number of respondents per hotel
numRespondents <- 0  #Placeholder to start vector
for(i in 1:396)  #Loop to build vector of respondents
{
  numRespondents <- c(numRespondents, length(npsdata$Property_ID_PL[npsdata$Property_ID_PL == uniqueHotelIDs[i]]))
}
numRespondents <- numRespondents[-1]  #Remove the initial 0 starting the vector
npsDataByHotel <- cbind(npsDataByHotel, numRespondents)

#Reset row numbers
rownames(npsDataByHotel) <- NULL
#Give new labels to columns 41-50
colnames(npsDataByHotel)[41:51] <- c("Overall_Sat_H", "Guest_Room_H", "Tranquility_H", "Condition_Hotel_H",
                                     "Customer_SVC_H", "Staff_Cared_H", "Internet_Sat_H", "Check_In_H",
                                     "FB_FREQ_H", "FB_Overall_Experience_H", "Num_Respondents")

#Do some initial analysis of NPS values
tapply(npsDataByHotel$Hotel_NPS, npsDataByHotel$State_PL, mean)  #Average NPS by state
tapply(npsDataByHotel$Hotel_NPS, npsDataByHotel$US_Region_PL, mean)  #Average NPS by US region
tapply(npsDataByHotel$Hotel_NPS, npsDataByHotel$Brand_PL, mean)  #Average NPS by hotel brand
summary(npsDataByHotel$Hotel_NPS)  #Initial descriptive stats of hotel NPS

#Histogram of Hotel NPS distributions
ggplot(npsDataByHotel, aes(x=Hotel_NPS))+
  geom_histogram(bins=100, color="black", fill="blue")+
  geom_vline(aes(xintercept=mean(Hotel_NPS)), color="red", linetype="dashed", size=1)+
  xlab("Hotel NPS Scores")+
  ggtitle("Hotel NPS Distribution")

#Which hotels have the highest NPS?
npsHotelDataSorted <- npsDataByHotel[order(-npsDataByHotel$Hotel_NPS),]  #Get a dataframe sorted by NPS
head(npsHotelDataSorted$Hotel_NPS, 15)  #Top 15 NPS values
head(npsHotelDataSorted$Hotel_Name_Long_PL, 15)  #Top 15 NPS hotels

#Which hotels have the lowest NPS?
tail(npsHotelDataSorted$Hotel_NPS, 15)  #Top 15 NPS values
tail(npsHotelDataSorted$Hotel_Name_Long_PL, 15)  #Top 15 NPS hotels

#Build column of whether or not hotels are meeting goals
meetingGoalsVec <- "START"  #Establish starting vector
for(i in 1:396)
{
  if(is.na(npsDataByHotel$Guest_NPS_Goal_PL[i]))
    meetingGoalsVec <- c(meetingGoalsVec, "NO GOAL SET")
  else
  {
    if(npsDataByHotel$Hotel_NPS[i] >= npsDataByHotel$Guest_NPS_Goal_PL[i])
      meetingGoalsVec <- c(meetingGoalsVec, "YES")
    else
      meetingGoalsVec <- c(meetingGoalsVec, "NO")
  }
}
meetingGoalsVec <- meetingGoalsVec[-1]  #Remove placeholder first string in vector

npsDataByHotel$isMeetingGoals <- meetingGoalsVec  #Append hotel NPS dataframe with vector of if goals being met
#How many hotels are at least meeting their NPS goals
length(npsDataByHotel$isMeetingGoals[npsDataByHotel$isMeetingGoals == "YES"])
#How many hotels are falling short of their NPS goals
length(npsDataByHotel$isMeetingGoals[npsDataByHotel$isMeetingGoals == "NO"])

#Build bar chart of hotels meeting goals vs. not meeting goals
g1 <- ggplot(npsDataByHotel, aes(x = isMeetingGoals)) + geom_bar(stat = "count", width = 0.5, fill = "blue")
g1 <- g1 + ggtitle("Number of Hotels Meeting NPS Goals")
g1 <- g1 + xlab("Is the hotel meeting their goals?") + ylab("Number of Hotels")
g1

#Prep data for map visualizations
npsHotelMapData <- npsDataByHotel[npsDataByHotel$State_PL != "District of Columbia",]  #Remove DC data
npsHotelMapData <- npsHotelMapData[npsHotelMapData$State_PL != "Hawaii",]  #Remove HI data to enable US map
npsHotelMapData <- npsHotelMapData[npsHotelMapData$State_PL != "Alaska",]  #Remove AK data to enable US map
colnames(npsHotelMapData)[4] <- "city"
colnames(npsHotelMapData)[5] <- "state"
npsHotelMapData$city <- tolower(npsHotelMapData$city)  #Make sure city column is lowercase
npsHotelMapData$state <- tolower(npsHotelMapData$state)  #Make sure state column is lowercase
npsHotelMapData$cityState <- paste(npsHotelMapData$city, npsHotelMapData$state)  #Create cityState column for geocode

View(npsHotelMapData)

#Create MakeGeoURL function to turn an address into a URL
MakeGeoURL <- function(address)
{
  root <- "http://maps.google.com/maps/api/geocode/"
  url <- paste(root, "json?address=", address, "&sensor=false", sep = "")
  return(URLencode(url))
}

#Create Addr2latlng function to turn an address into a latitude and longitude
Addr2latlng <- function(address)
{
  url <- MakeGeoURL(address)  #Set up URL string
  apiResult <- getURL(url)  #Send URL string to internet and store result 
  geoStruct <- fromJSON(apiResult, simplify = FALSE)  #Apply JSON notation
  lat <- NA
  lng <- NA
  try(lat <- geoStruct$results[[1]]$geometry$location$lat)  #Isolate latitude
  try(lng <- geoStruct$results[[1]]$geometry$location$lng)  #Isolate longitude
  return(c(lat, lng))
}

#Create ProcessAddrList function to turn an address list into a list of longitudes and latitudes
ProcessAddrList <- function(addrList)
{
  resultDF <- data.frame(atext = character(), X = numeric(), Y = numeric(), EID = numeric())
  k <- 1
  for(addr in addrList)
  {
    latlng <- Addr2latlng(addr)
    resultDF <- rbind(resultDF, data.frame(atext = addr, X = latlng[[2]], Y = latlng[[1]], EID = k))
    k <- k + 1
  }
  return(resultDF)
}

#Create npsMapPoints dataframe to store all latitudes and longitudes
npsMapPoints <- ProcessAddrList(npsHotelMapData$cityState)
colnames(npsMapPoints)[2] <- "lon"
colnames(npsMapPoints)[3] <- "lat"

#Add latitude and longitude to npsHotelMapData dataframe
npsHotelMapData$lon <- npsMapPoints$lon
npsHotelMapData$lat <- npsMapPoints$lat

#Try to capture lats and longs that were missed
for(z in 1:386)
{
  if(is.na(npsHotelMapData$lon[z]))
  {
    latlng <- Addr2latlng(npsHotelMapData$cityState[z])
    npsHotelMapData$lat[z] <- latlng[1]
    npsHotelMapData$lon[z] <- latlng[2]
  }
}

#Create dummy dataframe for map visualization
dummyDF <- data.frame(state.name, stringsAsFactors=FALSE)
dummyDF$state <- tolower(dummyDF$state.name)

#Create map visualization of hotels meeting goals vs. not meeting goals
us <- map_data("state")
m1 <- ggplot(dummyDF, aes(map_id = state))
m1 <- m1 + geom_map(map = us, fill = "white", color = "black")
m1 <- m1 + expand_limits(x = us$long, y = us$lat) + coord_map()
m1 <- m1 + ggtitle("Are US Hotels Meeting Goals?") + xlab("Longitude") + ylab("Latitude")
m1 <- m1 + geom_point(data = npsHotelMapData, aes(x = lon, y = lat, color = isMeetingGoals))
m1  #Display map graphic

#Create map visualization of hotels with above-average NPS and below-average NPS
meanNPS <- mean(npsDataByHotel$Hotel_NPS)
npsHotelMapData$isAboveAverage <- npsHotelMapData$Hotel_NPS >= meanNPS
m2 <- ggplot(dummyDF, aes(map_id = state))
m2 <- m2 + geom_map(map = us, fill = "white", color = "black")
m2 <- m2 + expand_limits(x = us$long, y = us$lat) + coord_map()
m2 <- m2 + ggtitle("Which US Hotels have above-average NPS?") + xlab("Longitude") + ylab("Latitude")
m2 <- m2 + geom_point(data = npsHotelMapData, aes(x = lon, y = lat, color = isAboveAverage))
m2  #Display map graphic

#Build boxplot of hotel NPS scores
b1 <- ggplot(npsDataByHotel, aes(x = factor(0), Hotel_NPS)) + geom_boxplot()
b1 <- b1 + ggtitle("Boxplot of Hotel NPS Scores")
b1  #Display the boxplot graphic

#Try some tapply expressions to see if there are notable differences between values above
tapply(npsDataByHotel$Hotel_NPS, npsDataByHotel$All_Suites_PL, mean)   #8 point difference
tapply(npsDataByHotel$Hotel_NPS, npsDataByHotel$Bell_Staff_PL, mean)   #-10 point difference
tapply(npsDataByHotel$Hotel_NPS, npsDataByHotel$Boutique_PL, mean)
tapply(npsDataByHotel$Hotel_NPS, npsDataByHotel$Business_Center_PL, mean)
tapply(npsDataByHotel$Hotel_NPS, npsDataByHotel$Casino_PL, mean)
tapply(npsDataByHotel$Hotel_NPS, npsDataByHotel$Conference_PL, mean)
tapply(npsDataByHotel$Hotel_NPS, npsDataByHotel$Convention_PL, mean)   #-8 point difference
tapply(npsDataByHotel$Hotel_NPS, npsDataByHotel$Dry_Cleaning_PL, mean)
tapply(npsDataByHotel$Hotel_NPS, npsDataByHotel$Elevators_PL, mean)
tapply(npsDataByHotel$Hotel_NPS, npsDataByHotel$Fitness_Center_PL, mean)
tapply(npsDataByHotel$Hotel_NPS, npsDataByHotel$Fitness_Trainer_PL, mean)
tapply(npsDataByHotel$Hotel_NPS, npsDataByHotel$Golf_PL, mean)
tapply(npsDataByHotel$Hotel_NPS, npsDataByHotel$Indoor_Corridors_PL, mean)
tapply(npsDataByHotel$Hotel_NPS, npsDataByHotel$Laundry_PL, mean)
tapply(npsDataByHotel$Hotel_NPS, npsDataByHotel$Limo_Service_PL, mean)
tapply(npsDataByHotel$Hotel_NPS, npsDataByHotel$MiniBar_PL, mean)
tapply(npsDataByHotel$Hotel_NPS, npsDataByHotel$Pool_Indoor_PL, mean)
tapply(npsDataByHotel$Hotel_NPS, npsDataByHotel$Pool_Outdoor_PL, mean)
tapply(npsDataByHotel$Hotel_NPS, npsDataByHotel$Regency_Grand_Club_PL, mean)
tapply(npsDataByHotel$Hotel_NPS, npsDataByHotel$Resort_PL, mean)
tapply(npsDataByHotel$Hotel_NPS, npsDataByHotel$Restaurant_PL, mean)   #-8 point difference
tapply(npsDataByHotel$Hotel_NPS, npsDataByHotel$Self_Parking_PL, mean)
tapply(npsDataByHotel$Hotel_NPS, npsDataByHotel$Shuttle_Service_PL, mean)
tapply(npsDataByHotel$Hotel_NPS, npsDataByHotel$Ski_PL, mean)
tapply(npsDataByHotel$Hotel_NPS, npsDataByHotel$Spa_PL, mean)
tapply(npsDataByHotel$Hotel_NPS, npsDataByHotel$Spa_services_in_fitness_center_PL, mean)
tapply(npsDataByHotel$Hotel_NPS, npsDataByHotel$Spa_online_booking_PL, mean)
tapply(npsDataByHotel$Hotel_NPS, npsDataByHotel$Spa_FB_offering_PL, mean)
tapply(npsDataByHotel$Hotel_NPS, npsDataByHotel$Valet_Parking_PL, mean)  #-9 point difference

#Build bar charts of above average/below average hotel NPS scores
npsDataByHotel$NPSisAboveAverage <- npsDataByHotel$Hotel_NPS >= meanNPS  #Add column to the dataframe

#All_Suites_PL stacked bar chart
b2 <- ggplot(npsDataByHotel, aes(x = NPSisAboveAverage, fill = factor(All_Suites_PL))) + geom_bar()
b2 <- b2 + ggtitle("High vs. Low NPS Hotels - All Suites or No?")
b2  #Display the bar chart

#Bell_Staff_PL stacked bar chart
b3 <- ggplot(npsDataByHotel, aes(x = NPSisAboveAverage, fill = factor(Bell_Staff_PL))) + geom_bar()
b3 <- b3 + ggtitle("High vs. Low NPS Hotels - Bell Staff or No?")
b3  #Display the bar chart

#Convention_PL stacked bar chart
b4 <- ggplot(npsDataByHotel, aes(x = NPSisAboveAverage, fill = factor(Convention_PL))) + geom_bar()
b4 <- b4 + ggtitle("High vs. Low NPS Hotels - Convention Center or No?")
b4  #Display the bar chart

#Restaurant_PL stacked bar chart
b5 <- ggplot(npsDataByHotel, aes(x = NPSisAboveAverage, fill = factor(Restaurant_PL))) + geom_bar()
b5 <- b5 + ggtitle("High vs. Low NPS Hotels - Restaurant or No?")
b5  #Display the bar chart

#Valet_Parking_PL stacked bar chart
b6 <- ggplot(npsDataByHotel, aes(x = NPSisAboveAverage, fill = factor(Valet_Parking_PL))) + geom_bar()
b6 <- b6 + ggtitle("High vs. Low NPS Hotels - Restaurant or No?")
b6  #Display the bar chart

#Attempt linear model to see if relationships exist between NPS and the other quantifiable survey variables
model1 <- lm(formula = Hotel_NPS ~ Guest_Room_H + Tranquility_H + Condition_Hotel_H + Customer_SVC_H
             + Staff_Cared_H + Internet_Sat_H + Check_In_H + FB_FREQ_H + FB_Overall_Experience_H
             + Hotel_Inventory_PL, data = npsDataByHotel)
summary(model1)
#Was not a fully successful model

#Based on results, refine linear model with only variables that have a low p-value
model2 <- lm(formula = Hotel_NPS ~ Guest_Room_H + Tranquility_H + Customer_SVC_H + Internet_Sat_H
             + FB_FREQ_H + FB_Overall_Experience_H + Hotel_Inventory_PL, data = npsDataByHotel)
summary(model2)
#This seems to be a good model!





####Create Subsets####
#Business Question 1 Subset
BQ1_Revenue <- subset(npsdata, select = c(Likelihood_Recommend_H,NPS_Type,PMS_ROOM_REV_USD_C,PMS_TOTAL_REV_USD_C,PMS_FOOD_BEVERAGE_REV_USD_C,PMS_OTHER_REV_USD_C,REVENUE_USD_R,Net_Rev_H,Room_Rev_H))
View(BG1_Revenue)

#Business Question 2 Subset
BQ2_HotelPerformance <- subset(npsdata, select = c(Likelihood_Recommend_H, Guest_NPS_Goal_PL, Property_ID_PL, Hotel_Name_Long_PL, Hotel_Name_Short_PL, Brand_Initial_PL))

#Business Question 3 Subset
BQ3_HotelChar <- subset(npsdata, select = c(Likelihood_Recommend_H, All_Suites_PL, Bell_Staff_PL, Boutique_PL, Business_Center_PL, Casino_PL, Conference_PL, Convention_PL, Dry_Cleaning_PL, Fitness_Center_PL, Fitness_Trainer_PL, Golf_PL, Indoor_Corridors_PL, Laundry_PL, Limo_Service_PL, MiniBar_PL, Pool_Indoor_PL, Pool_Outdoor_PL, Resort_PL, Restaurant_PL, Self_Parking_PL, Shuttle_Service_PL, Ski_PL, Spa_PL, Spa_services_in_fitness_center_PL, Spa_online_booking_PL, Spa_FB_offering_PL, Age_Range_H, Valet_Parking_PL, Overall_Sat_H, Guest_Room_H, Tranquility_H, Condition_Hotel_H, Customer_SVC_H, Staff_Cared_H, Internet_Sat_H, Check_In_H, FB_FREQ_H, FB_Overall_Experience_H, City_PL, State_PL, US_Region_PL, Postal_Code_PL))

#Business Question 4 Subset
BQ4_NPSDiff <- subset(npsdata, select = c(NPS_Type, Age_Range_H, Language_H, Guest_State_H, STATE_R, e_hy_gss_gender_I, Gender_H, e_hy_gss_tier_I, GP_Tier_H, GP_Tier, LENGTH_OF_STAY_C, Length_Stay_H, Booking_Channel, Guest_Checkout_Date_H, DEPARTURE_DATE_R, NT_RATE_R, ADULT_NUM_R, CHILDREN_NUM_R, Age_Range_H, Response_Date_H))
npsdata$Regency

#Business Question 5 Subset
BQ5_NPSFactors <- subset(npsdata, select = c(Likelihood_Recommend_H, NPS_Type, Overall_Sat_H, Guest_Room_H, Tranquility_H, Condition_Hotel_H, Customer_SVC_H, Staff_Cared_H, Internet_Sat_H, Check_In_H, FB_FREQ_H, FB_Overall_Experience_H, LENGTH_OF_STAY_C, Length_Stay_H, Age_Range_H, POV_H, Language_H, Guest_State_H, STATE_R, e_hy_gss_gender_I, Gender_H, e_hy_gss_tier_I, GP_Tier_H, GP_Tier))


#Visualizing BQ1
#Comparing individual NPS rating to revenue per individual
BQ1_Revenue$Likelihood_Recommend_H <- as.numeric(BQ1_Revenue$Likelihood_Recommend_H)
BQ1_Revenue$REVENUE_USD_R <- as.numeric(BQ1_Revenue$REVENUE_USD_R)
BQ1_Revenue$NPS_Type <- as.factor(BQ1_Revenue$NPS_Type)

summary(BQ1_Revenue$REVENUE_USD_R) #Look at revenue summary statistics
quantile(BQ1_Revenue$REVENUE_USD_R, probs = c(.5, .75, .99)) #Identify outliers
sum(BQ1_Revenue$REVENUE_USD_R > 2283) #See how many outliers exist (past 99th percentile)

RevSansOutliers <- subset(BQ1_Revenue, REVENUE_USD_R < 2283, select=c(REVENUE_USD_R, Likelihood_Recommend_H)) #Create subset that doesn't include outliers
RevSansOutliers$REVENUE_USD_R <- as.numeric(RevSansOutliers$REVENUE_USD_R)

ggplot(RevSansOutliers, aes(x=REVENUE_USD_R))+
  geom_histogram(bins=100, color="black", fill="blue")+
  geom_vline(aes(xintercept=mean(REVENUE_USD_R)), color="red", linetype="dashed", size=1)+
  xlab("Revenue per Guest")+
  ggtitle("Revenue per Guest Distribution")

hist(RevSansOutliers$REVENUE_USD_R, breaks=100) #Visualize revenue without outliers
View(RevSansOutliers)

View(BQ1_Revenue)

ggplot(BQ1_Revenue, aes(x=BQ1_Revenue$Likelihood_Recommend_H, y=BQ1_Revenue$REVENUE_USD_R))+
  geom_point(color="blue")+ 
  xlab("Likelihood to Recommend")+ 
  ylab("Revenue per Individual")+
  ggtitle("Revenue per Individual by Likelihood to Recommend")

BQ1model <- lm(formula = REVENUE_USD_R ~ Likelihood_Recommend_H, data=BQ1_Revenue)
summary(BQ1model)

tapply(BQ1_Revenue$REVENUE_USD_R, BQ1_Revenue$Likelihood_Recommend_H, mean) #Average guest revenue per Likelihood score
tapply(RevSansOutliers$REVENUE_USD_R, RevSansOutliers$Likelihood_Recommend_H, mean) #Average guest revenue per Likelihood score (minus outliers)

#Compare Hotel NPS to average revenue per room

RevPerHotel <- aggregate(npsdata$REVENUE_USD_R, list(npsdata$Hotel_Name_Long_PL), sum) #Creates df of total revenue per hotel
RoomsPerHotel <- aggregate(npsdata$Hotel_Inventory_PL, list(npsdata$Hotel_Name_Long_PL), mean) #Creates df of total rooms per hotel

colnames(RevPerHotel) <- c("Hotel_Name_Long_PL", "Total_Revenue")
colnames(RoomsPerHotel) <- c("Hotel_Name_Long_PL", "Number_of_rooms")

HotelRevRooms  <- merge(RevPerHotel,RoomsPerHotel, by=c("Hotel_Name_Long_PL")) #Combine RevPerHotel and RoomsPerHotel by hotel name

HotelRevRooms$Revenue_Per_Room <- HotelRevRooms$Total_Revenue / HotelRevRooms$Number_of_rooms #Calculate revenue per room for each hotel

npsDataByHotel <- merge(npsDataByHotel, HotelRevRooms, by = c("Hotel_Name_Long_PL")) #Add revenue per room to npsDataByHotel using the hotel name

summary(npsDataByHotel$Revenue_Per_Room)

ggplot(npsDataByHotel, aes(x=Revenue_Per_Room, y=Hotel_NPS))+
  geom_point(aes(color=isMeetingGoals))+
  geom_smooth(method=lm)+
  xlab("Revenue per Room")+ 
  ylab("Hotel NPS Score")+
  ggtitle("Revenue per Room by Hotel NPS Score")

cor(npsDataByHotel[,c("Hotel_NPS","Revenue_Per_Room")], use="complete") #Show correlation between the two variables

BQ1model2 <- lm(formula = Revenue_Per_Room ~ Hotel_NPS, data=npsDataByHotel)
summary(BQ1model2)

View(npsDataByHotel)

#Visualizing BQ4
#Count number of passives, promoters, detractors

NPSTypeCount <- ggplot(BQ4_NPSDiff, aes(x=NPS_Type))
NPSTypeCount + geom_bar(color="black", fill="blue") + ggtitle("Count of NPS Types") + theme(plot.title = element_text(hjust = 0.5))

#Compare NPS types by different attributes
BQ4_NPSDiff$Gender_H <- as.factor(BQ4_NPSDiff$Gender_H)
BQ4_NPSDiff$Age_Range_H <- as.factor(BQ4_NPSDiff$Age_Range_H)
BQ4_NPSDiff$CHILDREN_NUM_R <- as.factor(BQ4_NPSDiff$CHILDREN_NUM_R)

#NPS by gender
NPSGender <- ggplot(data=subset(BQ4_NPSDiff, !is.na(Gender_H)), aes(x=Gender_H))
NPSGender + geom_bar(aes(fill=NPS_Type)) 

#NPS by age
NPSAge <- ggplot(data=subset(BQ4_NPSDiff, !is.na(Age_Range_H)), aes(x=Age_Range_H))
NPSAge + geom_bar(aes(fill=NPS_Type))

#NPS by tier
NPSTier <- ggplot(data=subset(BQ4_NPSDiff, !is.na(e_hy_gss_tier_I)), aes(x=e_hy_gss_tier_I))
NPSTier + geom_bar(aes(fill=NPS_Type))

#NPS by number of children
NPSChild <- ggplot(data=subset(BQ4_NPSDiff, !is.na(CHILDREN_NUM_R)), aes(x=CHILDREN_NUM_R))
NPSChild + geom_bar(aes(fill=NPS_Type))

#NPS by number of adults
NPSAdult <- ggplot(data=subset(BQ4_NPSDiff, !is.na(ADULT_NUM_R)), aes(x=ADULT_NUM_R))
NPSAdult + geom_bar(aes(fill=NPS_Type))

#### BQ5 Visualization ####

# Create a grouped barplot for NPS type by guest gender
ggplot(BQ5_NPSFactors, aes(factor(Gender_H), ..count..)) + geom_bar(aes(fill = NPS_Type), position = "dodge") + xlab("Gender")+ ylab("Number of respondents")

# Create a grouped barplot for NPS type by guest’s purpose of visit
ggplot(BQ5_NPSFactors, aes(factor(POV_H), ..count..)) + geom_bar(aes(fill = NPS_Type), position = "dodge") + xlab("Purpose of Visit")+ ylab("Number of respondents")

# Create a grouped barplot for NPS type by guest age range
ggplot(BQ5_NPSFactors, aes(factor(Age_Range_H), ..count..)) + geom_bar(aes(fill = NPS_Type), position = "dodge") + xlab("Age Range")+ ylab("Number of respondents")

# Create a grouped barplot for NPS type by guest GP Tier
ggplot(BQ5_NPSFactors, aes(factor(GP_Tier_H), ..count..)) + geom_bar(aes(fill = NPS_Type), position = "dodge") + xlab("GP Tier")+ ylab("Number of respondents")

# Create a scatter plot for hotel NPS by Guest room satisfaction
ggplot(npsDataByHotel, aes(x=Guest_Room_H, y=Hotel_NPS)) + geom_point()

# Create scatter plots for hotel NPS by each category
ggplot(npsDataByHotel, aes(x=Tranquility_H, y=Hotel_NPS)) + geom_point()
ggplot(npsDataByHotel, aes(x=Condition_Hotel_H, y=Hotel_NPS)) + geom_point()
ggplot(npsDataByHotel, aes(x=Customer_SVC_H, y=Hotel_NPS)) + geom_point()
ggplot(npsDataByHotel, aes(x=Staff_Cared_H, y=Hotel_NPS)) + geom_point()
ggplot(npsDataByHotel, aes(x=Internet_Sat_H, y=Hotel_NPS)) + geom_point()
ggplot(npsDataByHotel, aes(x=Check_In_H, y=Hotel_NPS)) + geom_point()
ggplot(npsDataByHotel, aes(x=FB_FREQ_H, y=Hotel_NPS)) + geom_point()
ggplot(npsDataByHotel, aes(x=FB_Overall_Experience_H, y=Hotel_NPS)) + geom_point()

# Linear regression to how much the category can explain about the Hote NPS
lmOutput1 <- lm(Hotel_NPS ~ Guest_Room_H, data = npsDataByHotel)
summary(lmOutput1)

lmOutput2 <- lm(Hotel_NPS ~ Tranquility_H, data = npsDataByHotel)
summary(lmOutput2)
lmOutput3 <- lm(Hotel_NPS ~ Condition_Hotel_H, data = npsDataByHotel)
summary(lmOutput3)
lmOutput4 <- lm(Hotel_NPS ~ Customer_SVC_H, data = npsDataByHotel)
summary(lmOutput4)
lmOutput5 <- lm(Hotel_NPS ~ Staff_Cared_H, data = npsDataByHotel)
summary(lmOutput5)
lmOutput6 <- lm(Hotel_NPS ~ Check_In_H, data = npsDataByHotel)
summary(lmOutput6)
lmOutput7 <- lm(Hotel_NPS ~ Internet_Sat_H, data = npsDataByHotel)
summary(lmOutput7)
lmOutput8 <- lm(Hotel_NPS ~ FB_Overall_Experience_H, data = npsDataByHotel)
summary(lmOutput8)

# Multiple linear regression model
lmOutput <- lm(Hotel_NPS ~ Guest_Room_H + Tranquility_H + Condition_Hotel_H + Customer_SVC_H + Staff_Cared_H + Internet_Sat_H + Check_In_H + FB_Overall_Experience_H, data = npsDataByHotel)
summary(lmOutput)

#Note that the Hyatt Regency Irvine (3113) has some funky data: only 1 respondent and an NPS goal of 0.42
npsDataByHotel <- npsDataByHotel[-291,]  #Remove this funky data point to not mess up results

#Attempt SVM model to try to classify a hotel as "above average NPS" or "below average NPS"
#Build random indices and cut point for training and test data sets
randIndex <- sample(1:dim(npsDataByHotel)[1])  # Create random index
cutpoint2_3 <- floor(2 * dim(npsDataByHotel)[1] / 3)  # Create a 2/3 cutpoint and round the number
cutpoint2_3  # Check the 2/3 cutpoint

#Create training data set, which contains the first 2/3 of the data
trainData <- npsDataByHotel[randIndex[1:cutpoint2_3],]
head(trainData)  # Check head of training data

#Create test data, which contains the remaining 1/3 of the data
testData <- npsDataByHotel[randIndex[(cutpoint2_3 + 1):dim(npsDataByHotel)[1]],]
head(testData)  # Check head of test data

#Create a "goodNPS" variable. This variable will be either 0 or 1. It will be 0 if the NPS is below
#the average for all the hotel observations and 1 if it is equal to or above the average NPS calculated.

#Create a new variable named "goodNPS" in the training dataset
#goodNPS = 0 if NPS is below the average hotel NPS
#goodNPS = 1 if NPS is equal to or above the average hotel NPS
trainData$goodNPS <- ifelse(trainData$Hotel_NPS < meanNPS, 0, 1)
#Do the same thing for the test dataset
testData$goodNPS <- ifelse(testData$Hotel_NPS < meanNPS, 0, 1)
#Remove "Hotel_NPS" from the training data
trainData <- trainData[, -40]
#Remove "Hotel_NPS" from the test data
testData <- testData[, -40]

#See if we can accurately predict ‘good’ and ‘bad’ NPS for a hotel based on the other variables.
#Convert "goodNPS" in training data from numeric to factor
trainData$goodNPS <- as.factor(trainData$goodNPS)
#Convert "goodNPS" in test data from numeric to factor
testData$goodNPS <- as.factor(testData$goodNPS)

#Build a model using ksvm function, and use other relevant variables to predict
svmGood <- ksvm(goodNPS ~ Guest_Room_H + Tranquility_H + Condition_Hotel_H + Customer_SVC_H
                + Staff_Cared_H + Internet_Sat_H + Check_In_H + FB_FREQ_H + FB_Overall_Experience_H
                + Hotel_Inventory_PL, data = trainData, kernel = "rbfdot", kpar = "automatic", C = 10,
                cross = 10, prob.model = TRUE)
#Check the model
svmGood

View(testData)

#Test the model on the testing dataset, and compute the percent of "goodNPS" that was correctly predicted
goodPred <- predict(svmGood, testData)

#Create a dataframe that contains the exact "goodNPS" value and the predicted "goodNPS"
compGood1 <- data.frame(testData[,52], goodPred)
#Change column names
colnames(compGood1) <- c("test", "pred")
#Compute the percentage of correct cases
perc_ksvm <- length(which(compGood1$test == compGood1$pred)) / dim(compGood1)[1]
perc_ksvm

#Confusion matrix
results <- table(test = compGood1$test, pred = compGood1$pred)
print(results)

#Based on the confusion matrix and the high percentage of correctly predicted cases, this SVM model
#appears to be accurate!


tbl <- table(BQ5_NPSFactors$POV_H, BQ5_NPSFactors$Age_Range_H)
tbl
chisq.test(tbl)
View(npsDataByHotel)

tbl2 <- table(npsdata$Conference_PL, npsdata$POV_H)
tbl2

tapply(npsdata$Tranquility_H, npsdata$Age_Range_H, mean, na.rm=TRUE)
tapply(npsdata$FB_Overall_Experience_H, npsdata$Age_Range_H, mean, na.rm=TRUE)

tapply(npsdata$Tranquility_H, npsdata$POV_H, mean, na.rm=TRUE)
tapply(npsdata$FB_Overall_Experience_H, npsdata$POV_H, mean, na.rm=TRUE)



View(npsdata)
