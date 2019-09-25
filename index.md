## Opensource data and AED accessibility tracking

The article “OPEN DATA IN HEALTH-GEOMATICS: MAPPING AND EVALUATING PUBLICLY ACCESSIBLE DEFIBRILLATORS” attempts to use road networks to improve the calculation of the area in which an AED is useful. Traditionally, this is by done by creating a 100m buffer zone around the location of the AED, but the authors use a road network in Lombard, Italy, to calculate what they call a “realistic” approach. The catchment areas they created are 200-meter distances over roads from the location of the AED. The authors were attempting to determine whether geographical factors could determine which method was more effective in each scenario, concluding that the realistic method was useful in urbanized areas, but ineffective in less urban areas without extensive road systems.


The authors acquired their street and building information from the opensource mapping database OpenStreetMap. Land use information was also open source, coming from the Lombardy region geoportal. That the technology was open source wasn’t necessarily important for the study itself, but it means that the same method can be used to develop catchment areas for AEDS for any city that has been sufficiently mapped on OpenStreetMap. The street data also limited the conclusions of the paper because someone going to get an AED would be able to use footpaths, which are not accounted for in the street data, so the realistic catchment areas may actually be larger than calculated.

[link](https://www.int-arch-photogramm-remote-sens-spatial-inf-sci.net/XLII-4-W14/63/2019/)


## My first QGIS model

I made this model for finding direction and distance in my QGIS class

[my first QGIS model](model1.model3)

I used the model to calculate the direction and distance of the census tracts in Suffolk County, MA from the Central Business District of Boston, and showed how distance comparess to median gross rent in [this scatter plot](boston_scatterplot.html), as well as how direction compared to median gross rent in [this polar plot](polar_boston.html)

[Here](model1_v3.2.model3) is an updated version of the model that that uses an SQL transform function for geodesic measurements which are more accurate
