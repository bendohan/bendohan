
## Mapping tweets to a known disease epidemiology; a case study of Lyme disease in the United Kingdom and Republic of Ireland

The researchers behind this article used a deductive form of research. They hypothesized that parts of the British Isles which saw higher rates of lyme disease would also have more twitter activity about lyme disease, and their research both supported their hypothesis and was statistically significant. The author’s documented their research pretty thoroughly. The used the Twitter API to access twitter data, and then used the twitteR package in R to gather data from twitter. The query was a search for tweets containing “Lyme”, in a radius of 375 kilometers around the geographic center of Great Britain, and only English tweets. They did this nearly every day for a year. They then removed from that data all tweets with non-specific user locations, all tweets that were about a place with Lyme in its name, and all retweets. They then matched that data with a local authority region.

This research might be difficult to reproduce, due to the accessibility of the data. If the twitter API gave access to all twitter data it would be possible, even relatively easy. Because it does not, you would need to somehow access historical twitter data in order to reproduce this exact research. It is however, easily replicable, as the authors are very explicit about what their did to gather their dataset. The author’s are not explicit about what R packages they use in paring down the data, but given they gathered the data using R it seems that they likely also analyzed it in R. 

[Link to article](https://doi.org/10.1016/j.yjbinx.2019.100060)

-----------------------------------------------------------------------------------------------------------------------------

## Opensource data and AED accessibility tracking

The article “OPEN DATA IN HEALTH-GEOMATICS: MAPPING AND EVALUATING PUBLICLY ACCESSIBLE DEFIBRILLATORS” attempts to use road networks to improve the calculation of the area in which an AED is useful. Traditionally, this is by done by creating a 100m buffer zone around the location of the AED, but the authors use a road network in Lombard, Italy, to calculate what they call a “realistic” approach. The catchment areas they created are 200-meter distances over roads from the location of the AED. The authors were attempting to determine whether geographical factors could determine which method was more effective in each scenario, concluding that the realistic method was useful in urbanized areas, but ineffective in less urban areas without extensive road systems.


The authors acquired their street and building information from the opensource mapping database OpenStreetMap. Land use information was also open source, coming from the Lombardy region geoportal. That the technology was open source wasn’t necessarily important for the study itself, but it means that the same method can be used to develop catchment areas for AEDS for any city that has been sufficiently mapped on OpenStreetMap. The street data also limited the conclusions of the paper because someone going to get an AED would be able to use footpaths, which are not accounted for in the street data, so the realistic catchment areas may actually be larger than calculated.

[Link to article](https://www.int-arch-photogramm-remote-sens-spatial-inf-sci.net/XLII-4-W14/63/2019/)

[Return to Homepage](index.md)
