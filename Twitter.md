# Using Twitter Data for Research

## A Case Study looking at Hurricane Dorian, attempting to distinguish whether the storm itself or Trump's sharpie drawing generated more interest by looking at where people were tweeting about Dorian

This lab was based on gathering spatial twitter data through the Twitter API, using the R library rtweet. The data gathered was any tweet with the keyword "Dorian" Spatial twitter data comes in many forms; some data has specific coordinates, but the majority of twitter data that has some sort of spatial element is attributed to the bounding box of whatever spatial element that is, whether a city, a landmark, a state, or even an entire country. For this reason, we had to find the centroids of the bounding boxes, and then convert the datapoints to be geographically located in the center of those bounding boxes. We did not include large areas such as states or the whole United States in our analysis. That was for the spatial part of the analysis, which was done in PostGIS, QGIS, and GeoDa, but first we did some non-spatial analysis in R, using [this script](dorian.r) to look at the most common keywords in the tweets about Hurricane Dorian, as well as how these words were associated. The same R script was used to upload data in PostGIS and to take census data using the API

![most common keywords](Rplot.png)

This is a chart of the most common words in tweets about Hurricane Dorian, and while the prescence of "dorian" and "hurricane" is not particularly interesting, its very notable that 4 of the following 5 top keywords are about Trump's map alteration, rather than about the hurricane itself. Despite the fact that Dorian dealt historic damage to the Bahamas, with a death count in the hundreds if not thousands, the president's alteration of a NOAA map to include Alabama in Dorian's path was tweeted about more than the Bahamas were.

![word association map](Rplot01.png)

This is a word association map, showing all words that were included in over 30 tweets about dorian, and the closer they are to another word, the more they were used together in the same tweet. Its interesting that Fake News and most of the Trump-related words are not close together. In general, we see the trump related tweets concentrated in the left and center-left, while words about the actual hurricane spread out from around those tweets, showing that the sharpiegate related tweets were more likely to include the same keywords as other sharpiegate related tweets, while tweets about Dorian the hurricane were less likely to use th

Going back to the spatial data, I took the tweets and put them into my PostGIS database, then analyzed them using [this sql code](noteslab10.sql). The general idea was to create two new columns, one called tweetrate, which normalized the number of tweets by the population in the county the tweet was from, and another called normalized differential tweet index, which normalized the number of tweets by the number of tweets over the same period of time in November. 

Using this data, I created a heatmap showing which areas had the highest tweet rates about Dorian
![heatmap](heatmap.png)

The heatmap shows that the most tweets were along the east coast, areas that may have been hit by Dorian.

I also performed a Getis-Ord G* analysis of the tweet rate data in GeoDa (using [this weighting matrix](weighting_matrix.gwt). That created the map of concentrated heighs and lows by county seen below, as well as a map of the statistical signifigance of the difference.

![Getis Ord G*](geodamap.PNG)

![signifigance](geodamapsig.PNG)


