:: command to import rasters into testDSM postgis database on artemis, by Joseph Holler

K:\gg323\raster2pgsql\raster2pgsql -s 4326 -d UNEP_GRID\dr_physexp.tif public.droughtrisk  > droughtrisk.sql

K:\gg323\raster2pgsql\raster2pgsql -s 4326 -d UNEP_GRID\fl_physexp.tif public.floodexposure  > floodexposure.sql

:: K:\gg323\raster2pgsql\raster2pgsql UNEP_GRID\dr_physexp.tif public.floodrisk  > floodrisk.sql

pause

:: K:\gg323\raster2pgsql\raster2pgsql is the location of the raster2pgsql program on Splinter. If you save the program somewhere else, change this address It's normally installed in the program files\postgresql\12\bin folder of your postgresql server install. The number 12 will change with each postgresql version. PostGIS must be installed to the server, with raster support enabled.
:: -H 140.233.36.33 is the IP address for the PostGIS server, artemis. you can determine ip addresses of named network locations with a ping command, e.g. PING ARTEMIS
:: -P 5432 is the port for connecting to the database
:: -d database_name is the name of a database.  Change database_name to your own database name!
:: -U user_name is your user name. Change to your own user name!
:: -S dsm.style is a link to a style file. This assumes the style file is named dsm.style and saved in the same location as this batch script. If you move/rename the style file, change this link accordingly.
:: -W creates a password prompt, for connecting to your database
:: -l stores the data in wgs 1984 latitude,longitude, rather than pseudo mercator
:: -v verbose output, giving more information in the command prompt
:: -x creates extra attributes columns for the user name, user ID, time stamp... and I have added these extra entries into the dsm.style file.
:: K:\gg323\dsm_osm.osm the name of an OpenStreetMap file with data from the Dar es Salaam region, stored on Splinter so that we do not all have to download and copy this 1.5 gb file. You may download your own openstreetmap files from www.openstreetmap.org, and just add the .osm extension to any openstreetmap file you download. Alter the folder path and file name  if you move or rename the .osm file.
:: if you modify this, the tags are case-sensitive!
:: I attempted to use a -E tag to customize the projection to UTM zone 36 south 