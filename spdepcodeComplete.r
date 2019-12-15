#Using spdep to do spatial analysis of census data, written by Ben Dohan


#install packages for census and data management
install.packages(c("tidycensus","RColorBrewer","dplyr", "spdep"))

#load libraries
library(tidycensus)
library(RColorBrewer)
library(spdep)
library(dplyr)

#load and display American community survey variables - from https://walkerke.github.io/tidycensus/articles/basic-usage.html
variablesACS <- load_variables(2017, "acs5", cache = FALSE)
View(variablesACS)

#load and display census variables
variablesCensus <- load_variables(2010, "sf1", cache = FALSE)
View(variablesCensus)

#select the states to acquire data from, using two letter abbreviations
states <- c("NH", "ME", "VT", "MA", "CT", "RI", "NY", "PA", "NJ")

#select the variables to pull from the 2010 decennial census
#the number of urban and rural homes is not collected by the acs, therefore I used the census for it
decVar <- c(
  urban = "H002002",
  rural = "H002005")

#select the variables to pull from the 2017 american community survey
acsVar <- c(
  population = "B00001_001",
  bachelors = "B06009_005",
  medInc = "B06011_001",
  seasonal = "B25004_006"
)

#get a Census API here: https://api.census.gov/data/key_signup.html
#replace the key text 'insert key here' with your own key
#grab data from the acs, by county
dataACS <- get_acs("county", variables = acsVar, state = states, output="wide",geometry=TRUE,keep_geo_vars=TRUE, key="insert key here")

#replace the key text 'yourkey' with your own key
#grab data from the census, by county
dataCensus <- get_decennial(geography = "county", variables= decVar, state = states, output="wide",geometry=TRUE,keep_geo_vars=TRUE, key="insert key here") 

#turn the census data into a data frame
censusFrame<- as.data.frame(dataCensus)

#join the acs and census data into one data frame, using the GEOID tag as a unique ID true to both tables
censusTable<- left_join(dataACS, censusFrame, by = ("GEOID" = "GEOID"))

#calculate the number of seasonal homes per person by county 
censusTable <- within(censusTable, seasonPop <- seasonalE / populationE)

#calculate the percent of homes classified as rural by county
censusTable <- within(censusTable, ruralPCT <- rural / (urban+rural))

#calculate the percent of the population with a bachelors degree
censusTable <- within(censusTable, education <- bachelorsE/ populationE)

#check that everything is working by looking at the data
View(censusTable)

#run a linear regression on seasonal population
censusTable.lm <-lm(seasonPop~ruralPCT+medIncE+education, data=censusTable)

#view that regression
summary(censusTable.lm)

#create a neighbors list from the county polygons
censusTable.nb <- poly2nb(censusTable, row.names = "NAME.x.x", queen=TRUE)

#creating spatial weights from neighbors list, zero policy needs be true because 2 of the 217 counties have no neighbors
censusTable.lw <- nb2listw(censusTable.nb, glist=NULL, style="W", zero.policy =TRUE)

#run a global Moran's I for regression residuals on the regression, with a "greater" alternative hypothesis because I expect the residuals to be positive
residMoran <- lm.morantest(censusTable.lm, censusTable.lw, zero.policy = TRUE, alternative = "greater")

#view results of Moran's test
print(residMoran)

#run a local getis ord analysis on the seasonPop attribute
seasonG <- localG(censusTable$seasonPop, listw=censusTable.lw, zero.policy=TRUE)

#add the getis ord results to the dataframe
censusTable$seasonStar <- seasonG

#map the G* at a 1 z-score significance level
#set the color breaks, with breakpoints representing number of z-scores away from the mean
breaks <-c(-100,-1, 1)
#set the colors
colors <-c("purple", "white", "green")
#plot the map
plot(censusTable["seasonStar"], col=colors[findInterval(censusTable$seasonStar, breaks, all.inside = FALSE)], axes = FALSE, asp=T)
#add a title
title("G* of ratio of seasonal housing to population, 1 z-score significance")


#map the G* at a 2 z-score significance level
#set the color breaks, with breakpoints representing number of z-scores away from the mean
breaks <-c(-100,-2, 2)
#set the colors
colors <-c("purple", "white", "green")
#plot the map
plot(censusTable["seasonStar"], col=colors[findInterval(censusTable$seasonStar, breaks, all.inside = FALSE)], axes = FALSE, asp=T)
#add a title
title("G* of ratio of seasonal housing to population, 2 z-score significance")

#run another local Getis Ord analysis, this time on percent of population with a bachelors degree
edG <- localG(censusTable$education, listw=censusTable.lw, zero.policy=TRUE)

#add the bachelor's degree G* to the dataframe
censusTable$edStar <- edG

#map the second G* at a 2 z-score level
breaks <-c(-100,-2, 2)
colors <-c("purple", "white", "green")
plot(censusTable["edStar"], col=colors[findInterval(censusTable$edStar, breaks, all.inside = FALSE)], axes = FALSE, asp=T)
title("G* of percent of population with a Bachelor's degree, 2 z-score significance ")

#map the second G* at a 3 z-score level
breaks <-c(-100,-3, 3)
colors <-c("purple", "white", "green")
plot(censusTable["edStar"], col=colors[findInterval(censusTable$edStar, breaks, all.inside = FALSE)], axes = FALSE, asp=T)
title("G* of percent of population with a Bachelor's degree, 3 z-score significance ")

#export data for reproducibility
write.csv(censusTable,file="spdepData.csv")



