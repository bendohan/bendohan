:: command to import rasters into tpostgis database on artemis, by Joseph Holler

K:\gg323\raster2pgsql\raster2pgsql -s 4326 -d UNEP_GRID\dr_physexp.tif public.droughtrisk  > droughtrisk.sql

K:\gg323\raster2pgsql\raster2pgsql -s 4326 -d UNEP_GRID\fl_physexp.tif public.floodexposure  > floodexposure.sql

pause

:: K:\gg323\raster2pgsql\raster2pgsql is the location of the raster2pgsql program on Splinter. If you save the program somewhere else, change this address It's normally installed in the program files\postgresql\12\bin folder of your postgresql server install. The number 12 will change with each postgresql version. PostGIS must be installed to the server, with raster support enabled.
:: -d database_name is the name of a database.  Change database_name to your own database name!
:: -S dsm.style is a link to a style file. This assumes the style file is named dsm.style and saved in the same location as this batch script. If you move/rename the style file, change this link accordingly.


