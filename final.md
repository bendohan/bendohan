# OpenSource GIScience Final Project
### Various Function of the spdep spatial statistics package in RStudio

My goal in this project was to teach myself how to do some geogrpahical analysis in RStudio, as well as to familiarize myself with R and how it works for any future work I do in it. Although we used R in the twitter data labs, this was the first time I was writing my own R code from scratch. Specifically, my objective was to create and map the G* value of the ratio of seasonal homes to people by county, run a linear regression on the ratio of seasonal homes, and find the global Moran's I of the regression residuals. I chose these three tests because they are three different ways of analyzing data for trends. The G* looks at spatial clustering of just one value, a linear regression only looks at how different variables are related to the outcome and does not include spatial data, the global Moran's I for regression residuals uses spatial data, along with multiple variables because it is based on regression residuals

All the data used for the lab came from the United States Census Bureau, and I downloaded it in RStudio using a census API and the tidycensus package. Because I chose to pull in data from the Census Bureau, my first step to learning how to use spdep was learning how to use tidycensus. It was also my first time writing my own code in R, but fortunately it functions a lot like javascript (which I have experience using in google earth engine) so it wasn't too difficult to pick up. It also took a bit of time to figure out how to use tidycensus. I had access to the creators help document, but even then I had to work around making the code actually work. I wanted to do the analysis at the county subdivision (town/city) level, but I couldnt successfully make the code work when I searched for "county subdivision" instead of "county" as my geography. I ended doing the analysis at the county level, although later I discovered that I could call the data one state at a time at the county subdivision level, and it would be possible to do that then aggregate it all into one table.

The research I conducted is entirely OpenSource, as it only uses software that can be freely downloaded off the internet, and census data which can also be downloaded for free, even without the API, which can be acquired through a free and easy process. The data is both replicable, with the R script I have provided, and reproducible. If you want to do a similar analysis of different census data, or in a different region of the United States, it only requires minor changes to the attributes that are pulled from the census, and the variable names in functions. Even if you do the analysis using a different dataset, you would need to upload the data in a different manner but the functions and visualization should work the same.





------------------------------------------------------------------------------------------------------------------------------
Tutorials used:

https://rstudio-pubs-static.s3.amazonaws.com/126356_ef7961b3ac164cd080982bc743b9777e.html
http://labs.bio.unc.edu/buckley/documents/anselinintrospatregres.pdf
