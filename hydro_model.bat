:: Ben Dohan
:: This script is designed to create a channel network from a DEM

::set the path to your SAGA program
SET PATH=%PATH%;c:\saga6

::set the prefix to use for all names and outputs
SET pre=srtm5

::set the directory in which you want to save ouputs. In the example below, part of the directory name is the prefix you entered above
SET od=W:\GIS\OSlab4\%pre%

:: the following creates the output directory if it doesn't exist already
if not exist %od% mkdir %od%

:: Run Mosaicking tool, with consideration for the input -GRIDS, the -
saga_cmd grid_tools 3 -GRIDS=S04E037_elevation.sgrd;S03E037_elevation.sgrd -NAME=%pre%Mosaic -TYPE=9 -RESAMPLING=0 -OVERLAP=1 -MATCH=0 -TARGET_OUT_GRID=%od%\%pre%mosaic.sgrd

:: Run UTM Projection tool
saga_cmd pj_proj4 24 -SOURCE=%od%\%pre%mosaic.sgrd -RESAMPLING=0 -KEEP_TYPE=1 -GRID=%od%\%pre%mosaicUTM.sgrd -UTM_ZONE=37 -UTM_SOUTH=1

:: Run Analytical hillshade tool, with consideration for the input -GRIDS, the -
saga_cmd ta_lighting 0 -ELEVATION=%od%\%pre%mosaicUTM.sgrd -SHADE=%od%\%pre%Hillshade.sgrd -METHOD=0 -POSITION=0 -AZIMUTH=315 -DECLINATION=45 -EXAGGERATION=1 -UNIT=0

:: Run Sink Drainage route tools
saga_cmd ta_preprocessor 1 -ELEVATION=%od%\%pre%mosaicUTM.sgrd -SINKROUTE=%od%\%pre%sink_route.sgrd -THRESHOLD=0 -THRSHEIGHT=100.000000

:: Run Sink Removal
saga_cmd ta_preprocessor 2 -DEM=%od%\%pre%mosaicUTM.sgrd -SINKROUTE=%od%\%pre%sink_route.sgrd -DEM_PREPROC=%od%\%pre%sinks_removed.sgrd

::Run Flow Accumulation (Top-down)
saga_cmd ta_hydrology 0 -ELEVATION=%od%\%pre%sinks_removed.sgrd -SINKROUTE=%od%\%pre%sink_route.sgrd -WEIGHTS=NULL -FLOW=%od%\%pre%flow_ac.sgrd -VAL_INPUT=NULL -ACCU_MATERIAL=NULL -STEP=1 -FLOW_UNIT=0 -FLOW_LENGTH=NULL -LINEAR_VAL=NULL -LINEAR_DIR=NULL -METHOD=4 -LINEAR_DO=1 -LINEAR_MIN=500 -CONVERGENCE=1.1

::Run Channel Network
saga_cmd ta_channels 0 -ELEVATION=%od%\%pre%sinks_removed.sgrd -SINKROUTE=NULL -CHNLNTWRK=%od%\%pre%channel_network.sgrd -CHNLROUTE=%od%\%pre%channel_route.sgrd -SHAPES=%od%\%pre%channel_vector.shp -INIT_GRID=%od%\%pre%flow_ac.sgrd -INIT_METHOD=2 -INIT_VALUE=1000 -DIV_GRID=NULL -DIV_CELLS=5 -TRACE_WEIGHT=NULL -MINLEN=10

::print a completion message so that uneasy users feel confident that the batch script has finished!
ECHO Processing Complete!
PAUSE