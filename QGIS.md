
## My first QGIS model

I made this model for finding direction and distance in my QGIS class

[my first QGIS model](model1.model3)

[Here](model1_v3.2.model3) is an updated version of the model that that uses an SQL transform function for geodesic measurements which are more accurate

I used the updated model to calculate the direction and distance of the census tracts in Suffolk County, MA from the Central Business District of Boston, and showed how distance comparess to median gross rent in [this scatter plot](boston_scatterplot.html), as well as how direction compared to median gross rent in [this polar plot](polar_boston.html)

This new model compensates for differences in projections by reprojecting all inputs in wgs 1984, where distance is always accurate, through an sql query and calculating this distance between the cbd and other points after this. 

The model can be seen here
![updated model](model.PNG)

Is a map of the directions it calculated for each census tract from the CBD of Boston
![direction map](direction_boston.png)

Here is a map of the distances for each census tract from the CBD of Boston
![distance map](distance_boston.png)
