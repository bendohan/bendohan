# SQL GIS and online mapping

## An interactive urban resilience excercise: Accessibility in Dar es Salaam, Tanzania

This excercise is based around using Opensource data and GIS to measure Urban Resiliency. We will use data from Dar es Salaam, Tanzania, which is one of the best mapped regions on [OpenStreetMap](https://www.openstreetmap.org/#map=4/38.01/-95.84). This is a massive dataset, and so we will need to pick and choose what data we want to use, then isolate that data. I also used subward data from [Ramani Huria](https://ramanihuria.org/)

To upload data from OpenStreetMap in my PostGIS database, I used a program called osm2pgsql, which can be accessed [on github](https://github.com/openstreetmap/osm2pgsql).

Our goal is to determine which houses are accessible by roads and paths and which are not. The gameplan is to create buffers around the roads that reach only the layer of houses that are adjacent to the roads. Those will be the houses which we determine to be accessible, and the other houses will be deemed inaccessible. Once you have the data, you can look through the attributes. We will be using the columns 'highway', 'width', 'building', and 'amenity,' so those are the only ones you need to upload from OSM. You will also notice the data is extremely messy, and not everything is input the way we would want it to be. Our first steps will be to clean up the data a bit. We want the width column to function as an integer, but right now it is a string datatype. The main problems are that people entered data with 'm' or 'meters' at the end, and some data has O's where it should have 0's. We can solve this with two SQL lines:

_STEP 1:_
>update planet_osm_line set width = replace(width, 'O', '0') 

>update planet_osm_line set width = trim(width, ' Mmetrs')

The first line here replaces any O's with zeros, and the second line removes anything after it detects an M. So, if a user entered a width value as '1o meters', it becomes '10'.

Now we need to turn what had been a string data type into a integer so we can use it in later calculations. Although it is possible to recast columns, its often easier to simply create a new column and populate it with the same information but give it the correct data type, which is what we will do here

_STEP 2:_
>ALTER TABLE planet_osm_line ADD COLUMN nwidth float
>UPDATE planet_osm_line SET nwidth = CAST(width AS float) WHERE highway IS NOT NULL

The first line creates a new width column that is a float, and the second line populates it with the same data that was being stored in width, but only for roads and paths (highway is the identifier here) because we don't want to use any other data in our analysis. In this case, we are mainly removing drains, which also have width values.

_STEP 3:_
>UPDATE planet_osm_line SET nwidth = 0 WHERE highway IS NOT NULL AND nwidth is null

This step is to give all highways a width, because if we attempt to calculate a buffer using the width of the road and the width is NULL, that road won't be included in the calculation, but if they are 0 they will be included, without making up any data.

_STEP 4:_
>ALTER TABLE planet_osm_line ADD COLUMN distinction integer

>UPDATE planet_osm_line SET distinction = 1 WHERE highway = 'trunk' or highway = 'trunk_link' or highway = 'primary' or highway = 'primary_link'

>UPDATE planet_osm_line SET distinction = 0 WHERE  highway = 'yes'  OR highway =  'unclassified' OR  highway  =  'bridleway' OR  highway = 'construction' OR  highway = 'cycleway' OR highway = 'footway' OR  highway = 'path' OR highway = 'pedestrian' OR highway = 'residential' Or highway=  'road'  OR highway = 'secondary' OR highway = 'secondary_link' OR  highway = 'service' OR  highway = 'steps' OR highway = 'tertiary' Or highway = 'tertiary_link' OR highway = 'track' 

Here we have created a new column to distinguishe between large roads and small roads/paths because houses are set further back from the large roads, so we need a larger buffer for them, but if we use a larger buffer on the small roads then we will be capturing more houses than we want in the analysis

_STEP 5:_
>CREATE TABLE buffer7 as

>SELECT nwidth, distinction

>CASE

>WHEN distinction = 1 then ST_Buffer(Geography(way), 18+nwidth/2, 'endcap=round')

>when distinction = 0 then ST_Buffer(Geography(way), 5+nwidth/2, 'endcap=round')

>end as link

>FROM planet_osm_line 

>WHERE highway is not null

Now we have created the buffer. Notice that for large roads the base size of our buffer is 18 meters, but for the smaller one it is 5 meters. Step 4 allowed us to use a case statement to make this happen. We name this buffer link, and only do it where highway is not null so that we are sure we are only buffering roads and paths. We turned the geometry into a geography value because that turns the units into meters, when before they were in degrees.

With our buffers created, we need to prepare the houses layer that we want to use the buffer to count.

_STEP 6:_
>create table home as 

>SELECT building, amenity, way::geometry(4326, 'polygon')  FROM planet_osm_polygon WHERE building = 'yes' AND amenity IS NULL OR building = 'residential'

This creates a new table from the osm polygon data that extracts only the residential houses and buildings of unknown use. It also forces the geometry data to be polygons. This data may appear in several different forms in the database, which can be solved with another query:
select populate_geometry_columns()

Next up is comparing the buffer and home layers to test accessibility

_STEP 7:_
>ALTER table home ADD COLUMN linkage float

>update buffer7 set geom = link::geometry('polygon', 4326)

>UPDATE home set linkage = distinction FROM buffer7 WHERE st_intersects(way, geom)

The first two lines allow the third line to run. The first line adds a new column that will tell us whether the home intersects a large road, a small road, or no road. The second line changes the geography of the buffer into a geometry so we can use it for the third step, and intersection between the home layer and the buffer layer. The distinction value from the buffer will be attached to any houses it intersects with. Now its time to bring in the subward layer from Resilience Academy

_STEP 8:_
ALTER table home ADD COLUMN subward integer

>UPDATE home

>SET subward = fid

>FROM subwardra

>WHERE ST_Intersects(way, ST_makeValid(geom))

We start off step 8 by adding a new column to the home layer that gives us a location to store the data about which subward the house is in. The second step runs an intersection nearly identical to the one from step 7, but in this case we are comparing the house to the subward. There is also the 'ST_makeValid' function in there, which fixes invalid geometries. Once this is done, each house should have the fid of the polygon from the resilience academy subwards attached to it. Next up is prepping the data to count accessible homes and inaccessible homes.

_STEP 9:_
>ALTER table home add column access integer

>UPDATE home

>set access = 1 WHERE linkage IS NOT NULL

>UPDATE home

>set access = 0 WHERE linkage IS NULL

These three querys add a new column where we can store whether the house is accessible or not in, and then we make that equal 1 if the house has a linkage value (intersected a buffer) or 0 if the house has no linkage value because it didn't intersect any buffer. Now we can count the accessible homes.

_STEP 10:_
>create table acc as 

>select subward, count(access) as acY from home

>WHERE access = 1

>group by subward
 
>create table total as 

>select subward, count(access) as acY from home

>group by subward

The two querys in this step are almost the same, but the first one only counts the accessible homes, and the second one counts all the homes. The 'Group By' function means that we get the number of home/accessible homes in each subward in the output table. Now we have out counts, but these new tables have no geometry so we can't visualize anything.

_STEP 11:_
>alter table subwardra add column allhomes2 float

>update subwardra 

>set allhomes2 = acT FROM test5 WHERE acc.subward = subwardra.fid

>alter table subwardra add column sherlockhomes2 float

>update subwardra 

>set sherlockhomes2 = acY FROM test6 WHERE total.subward = subwardra.fid

In this step we take data from the tables we created in step 10 and we put that data back into our subwards attribute table with a column for accessible homes and a column for inaccessible homes. Although these numbers are integers, it is important to use the float data type because they are too long for the integer data type. We are able to combine from these two tables because they both have the fid unique identifier. Now its time to calculate the percent of accessible homes in each subward.

_STEP 12:_
>alter table home add column pctaccess float

>update subwardra

>set pctaccess = (sherlockhomes/allhomes *100)

Now we have a new column with a value from each subward that contains the percent of homes that are accessible by road or path in that subward. You can now visualize that data and see what it looks like. Congratulations! We can still make the map a little more interesting...

_STEP 13:_
>create table health as

>SELECT building, amenity, way FROM planet_osm_polygon

>where building = 'hospital' or amenity = 'hospital' or amenity = 'doctors' or building = 'doctors'

This query creates a new table that isolates the healthcare options in Dar es Salaam. This is important because it will be hard to get emergency responders to inaccessible homes, meaning people whose homes are not accessible by road or path will have to wait longer to receive aid. If you add this layer to your map, it provides more information about which parts of the city are vulnerable. It would be nice to add roads to the map, but the file is too large for leaflet to be able to properly load it.

I made a [leaflet map](dsmap/index.html) showing the percent of houses in each subward accessible by road, with the healthcare options overlaid.

The general pattern in the map is that districts closer to the city center tend to be more accessible, but in the outskirts of the city many homes are not adjacent to any road or path.

[Here is an SQL file with the SQL code](sqllab6.sql)

[Click here to go back to my homepage](index.md)
