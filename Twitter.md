# Using Twitter Data for Research

## A Case Study looking at Hurricane Dorian, attempting to distinguish whether the storm itself or Trump's sharpie drawing generated more interest by looking at where people were tweeting about Dorian

This lab was based on gathering spatial twitter data through the Twitter API, using the R library rtweet. The data gathered was any tweet with the keyword "Dorian" Spatial twitter data comes in many forms; some data has specific coordinates, but the majority of twitter data that has some sort of spatial element is attributed to the bounding box of whatever spatial element that is, whether a city, a landmark, a state, or even an entire country. For this reason, we had to find the centroids of the bounding boxes, and then convert the datapoints to be geographically located in the center of those bounding boxes. That was for the spatial part of the analysis, which was done in PostGIS, QGIS, and GeoDa, but first we did some non-spatial analysis in R, using [this script](dorian.r) to look at the most common keywords in the tweets about Hurricane Dorian, as well as how these words were associated. 

![most common keywords](Rplot.png)
