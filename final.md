# OpenSource GIScience Final Project
### Various Function of the spdep spatial statistics package in RStudio

My goal in this project was to teach myself how to do some geogrpahical analysis in RStudio, as well as to familiarize myself with R and how it works for any future work I do in it. Although we used R in the twitter data labs, this was the first time I was writing my own R code from scratch. Specifically, my objective was to create and map the G* value of the ratio of seasonal homes to people by county, run a linear regression on the ratio of seasonal homes, and find the global Moran's I of the regression residuals. I chose these three tests because they are three different ways of analyzing data for trends. The G* looks at spatial clustering of just one value, a linear regression only looks at how different variables are related to the outcome and does not include spatial data, the global Moran's I for regression residuals uses spatial data, along with multiple variables because it is based on regression residuals

All the data used for the lab came from the United States Census Bureau, and I downloaded it in RStudio using a census API and the tidycensus package 

