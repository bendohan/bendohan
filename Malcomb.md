# Reproducibility in Geographic Research
## Malcomb et al, (2014): Vulnerability modeling for sub-Saharan Africa: An operationalized approach in Malawi

The focus of this lab was to investigate reproducibility and replicability in geographic research. We looked specifically at one article that was attempting to quantify social vulnerbality in Malawi. We started off by looking for Malcomb's data, and found some of it, but not all of it. Malcomb used data from the Department of Health Surveys, UNEP GLobal Risk, and FEWSNet. Our professor was able to acquire the DHS data, but it you do need to apply to use it. The UNEP data is availible to anyone online, but Malcomb was not clear about which data sources he used, so we had to take an educated guess, and we were unable to find the FEWSNet data.

The DHS surveys were conducted between 2004 and 2010, and although we don't know when the flood risk and drought exposure layers are updated we do, those are likely to change much slower than the DHS survey data so the research should be representative of the time period 2004-2010. 

We uploaded this data into PostGIS using [this R script](rtransscript.r)

Due to legal restrictions on the data, we the students we unable to look at the data, but we looked at the metadata, and from that we were able to develop an SQL script that isolated the data we wanted. We then put it into quantiles (with our best guess as to how Malcomb did it), and attached the survey points to the traditional authorities that Malcomb used in his analysis. We used the EPSG:4326 projection, but don't know for sure what projection was used in the paper.

The adaptive capacity scores in the traditional authorities produced the map below
![capacity scores](capacity.png)

The SQL queries we used are [included here](vulnerabilitySQL.sql)

Using the hierarchical chart showing the weights given to each factor, we attempted to recreate the map of vulnerability that Malcomb et al created. The flood risk and drought risk layers were in different pixel sizes, so we made the map in both, although we can tell that the authors used the smaller size, which was 0.416667. We used [a model in QGIS](vuln_rd2_works.model3) that approximates the steps we guessed that Malcomb et al took in creating their map.

We pulled the UNEP rasters in PostGIS using [this batch script](convertRaster.bat).

Here is the map at the larger resolution

![large vulnerability raster](vulnerbility.PNG)

Here is the map at the smaller resolution, the one used by Malcomb et al

![small vulnerability raster](vulnerability_small.PNG)

For comparison, the map that Malcomb et al produced
![Malcomb vulnerability scores](Malcomb_vul.png)

Neither map looks exactly like the map in the original paper, but they are relatively similar in terms of the results output, and it is impossible to know whether differences are due to us not following the same steps Malcomb et al followed, or due to us not being able to access all the same data that Malcomb accessed.

Both reproducibility and replicability are poor in the article. Without the data included, its hard to access it all, such as the mysterious FEWSNet data (although Malcomb can't be blamed for the fact that the DHS data needs to be applied for). But beyond that, the author's are not specific about what data they use from those DHS surveys and from UNEP, so we had to guess. Pieces of what they did are replicable, but without specific GIS methods and tools its impossible to know whether we are doing exactly what they did, and it also requires the data they used being availible in all countries.

Another issue with the data is the uncertainity, as the authors attach the dhs survey points to traditional authorities, but those surveys are intentionally placed within a random buffer area (5km for rural points and 2 km for urban) to protect personal data, and although they are kept within their district, traditional authorities are smaller than districts and so survey points could be attributed to traditional authorities which they are not actually in.

One of the most important things we can do as geographers is to include the data we used, or specific instructions on how to access that data, in our reports. It is also important to include what was done in GIS to turn the data into our result. That should mean detailed descriptions of what was done and maybe a workflow, and also attaching a model if one was used in the analysis.

Malcom uses what Tate (2012) calls a hierarchichal approach. This because it is based on a hypothesis, making it deductive, and also creates a structure of how the variables are organized, with several variables underneath three broader categories.

Another problem is that the way vulnerability was measured here is flawed. We have no idea how accurate the DHS survey's are, and its very posible people simply lied on them, especially given that there is a history of mistrust between locals and aid organizations. In fact, using the data sources Malcomb et al used might not be accurately measuring vulnerability. The author's only included local knowledge in deciding which DHS survey factors were the most important, so there might be other, very important factors that contribute to vulnerability that are not included here. Malcomb et al also gave each factor its own weighting, and what is essentially their best guess at how important each DHS survey category is could be completely wrong. At a deeper level, there is the issue that Hinkel (2011) brings up, which is that there is no clear definition of what constitutes vulnerability, as it a concept created by researchers. Hinkel attempts to create his answer to what is vulnerability, but really it is entirely subjective based on the ideas of the researchers, even if it is driven by previous investigations and theory.

-----------------------------------------------------------------------------------------------------------------------------

Malcomb, D. W., Weaver, E. A., & Krakowka, A. R. (2014). Vulnerability modeling for sub-Saharan Africa: An operationalized approach in Malawi. Applied Geography, 48, 17–30. https://doi.org/10.1016/j.apgeog.2014.01.004

Tate, E. (2012). Social vulnerability indices: A comparative assessment using uncertainty and sensitivity analysis. Natural Hazards, 63(2), 325–347. https://doi.org/10.1007/s11069-012-0152-2

Hinkel, J. (2011). “Indicators of vulnerability and adaptive capacity”: Towards a clarification of the science–policy interface. Global Environmental Change, 21(1), 198–208. https://doi.org/10.1016/j.gloenvcha.2010.08.002

