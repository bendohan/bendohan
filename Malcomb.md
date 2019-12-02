# Reproducibility in Geographic Research
## Malcomb et al, (2014): Vulnerability modeling for sub-Saharan Africa: An operationalized approach in Malawi

The focus of this lab was to investigate reproducibility and replicability in geographic research. We looked specifically at one article that was attempting to quantify social vulnerbality in Malawi. We started off by looking for Malcomb's data, and found some of it, but not all of it. Malcomb used data from the Department of Health Surveys, UNEP GLobal Risk, and FEWSNet. Our professor was able to acquire the DHS data, but it you do need to apply to use it. The UNEP data is availible to anyone online, but Malcomb was not clear about which data sources he used, so we had to take an educated guess, and we were unable to find the FEWSNet data.

Due to legal restrictions on the data, we the students we unable to look at the data, but we looked at the metadata, and from that we were able to develop an SQL script that isolated the data we wanted. We then put it into quantiles (with our best guess as to how Malcomb did it), and attached the survey points to the traditional authorities that Malcomb used in his analysis.

The SQL queries we used are [included here](vulnerabilitySQL.sql)

Using the hierarchical chart showing the weights given to each factor, we attempted to recreate the map of vulnerability that Malcomb et al created. The flood risk and drought risk layers were in different pixel sizes, so we made the map in both, although we can tell that the authors used the smaller size

Here is the map at the resolution used by Malcomb et al

![small vulnerability raster](Vulnerability.PNG)

![large vulnerability raster](vulnerability_large.PNG)
