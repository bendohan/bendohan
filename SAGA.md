## Using SAGA for modeling Channel Flow

![Original Mosaic of SRTM data showing Mt. Kilimanjaro](mosaic_map.png)
![legend](mosaic_map_legend.png)

I made this map in SAGA using two SRTM rasters and mosaicking them together. Its a basic DEM that shows the elevation of Mount Kilimanjaro.

![Hillshade model using original DEM](hillshade_image.png)
![legend](hillshade_image_legend.png)

This second map is a hillshade model based on the DEM above. The azimuth is 315 degrees and the altitude is 45 degrees. I produced it using the analytical hillshading tool in SAGA.

![Map of sink routes from DEM](sink_route_map.png)
![legend](sink_route_map_legend.png)

This map shows the sinks in the DEM image, which are spots where one pixel is lower than the surrounding pixels

![Map of DEM without any sinks](sinkfill_dem_map.png)
![legend](sinkfill_dem_map_legend.png)

This is a new DEM built from the original Mosaicked DEM and the sink routes image. Although it looks basically identical to the original DEM, it has filled the sinks revealed in the sink routes so that they do not interfere with channel identification.

![Map of flow accumulation](flow_accumulation2.png)
![legend](flow_accumulation2_legend.png)

![Map of channel network from flow accumulation](channel_network2.png)
![legend](channel_network2_legend.png)

![Map of channel direction](channel_direction_map.png)
![legend](channel_direction_map_legend.png)

![Map of channels and hillshade](dem_channels.png)
![legend](dem_channels_legend.png)
