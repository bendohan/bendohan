## SQL GIS and online mapping:
## An interactive urban resilience excercise

This excercise is based around using Opensource data and GIS to measure Urban Resiliency. We will use data from Dar es Salaam, Tanzania, which is one of the best mapped regions on OpenStreetMap. This is a massive dataset, and so we will need to pick and choose what data we want to use, then isolate that data.

Our goal is to determine which houses are accessible by roads and paths and which are not. The gameplan is to create buffers around the roads that reach only the layer of houses that are adjacent to the roads. Those will be the houses which we determine to be accessible, and the other houses will be deemed inaccessible. Once you have the data, you can look through the attributes. We will be using the columns 'highway', 'width', 'building', and 'amenity'. You will also notice the data is extremely messy, and not everything is input the way we would want it to be. Our first steps will be to clean up the data a bit. We want the width column to function as an integer, but right now it is a string datatype. The main problems are that people entered data with 'm' or 'meters' at the end, and some data has O's where it should have 0's. We can solve this with two SQL lines:
STEP 1:
update planet_osm_line set width = replace(width, 'O', '0') 

update planet_osm_line set width = trim(width, ' Mmetrs')

The first line here replaces any O's with zeros, and the second line removes anything after it detects an M. So, if a user entered a width value as '1o meters', it becomes '10'.

Now we need to turn what had been a string data type into a integer so we can use it in later calculations. Although it is possible to recast columns, its oftene easier to simply create a new column and populate it with the same information but give it the correct data type, which is what we will do here
STEP 2:
ALTER TABLE planet_osm_line ADD COLUMN nwidth float

UPDATE planet_osm_line SET nwidth = CAST(width AS float) WHERE highway IS NOT NULL

The first line creates a new width column that is a float, and the second line populates it with the same data that was being stored in width, but only for roads and paths (highway is the identifier here) because we don't want to use any other data in our analysis. In this case, we are mainly removing drains, which also have width values.
STEP 3:
UPDATE planet_osm_line SET nwidth = 0 WHERE highway IS NOT NULL AND nwidth is null

This step is to give all highways a width, because if we attempt to calculate a buffer using the width of the road and the width is NULL, that road won't be included in the calculation, but if they are 0 they will be included, without making up any data.

STEP 4:
ALTER TABLE planet_osm_line ADD COLUMN distinction integer

UPDATE planet_osm_line SET distinction = 1 WHERE highway = 'trunk' or highway = 'trunk_link' or highway = 'primary' or highway = 'primary_link'

UPDATE planet_osm_line SET distinction = 0 WHERE  highway = 'yes'  OR highway =  'unclassified' OR  highway  =  'bridleway' OR  highway = 'construction' OR  highway = 'cycleway' OR highway = 'footway' OR  highway = 'path' OR highway = 'pedestrian' OR highway = 'residential' Or highway=  'road'  OR highway = 'secondary' OR highway = 'secondary_link' OR  highway = 'service' OR  highway = 'steps' OR highway = 'tertiary' Or highway = 'tertiary_link' OR highway = 'track' 

Here we have created a new column to distinguishe between large roads and small roads/paths because houses are set further back from the large roads, so we need a larger buffer for them, but if we use a larger buffer on the small roads then we will be capturing more houses than we want in the analysis

STEP 5:
CREATE TABLE buffer7 as
SELECT nwidth, distinction

CASE
WHEN distinction = 1 then ST_Buffer(Geography(way), 18+nwidth/2, 'endcap=round')
when distinction = 0 then ST_Buffer(Geography(way), 5+nwidth/2, 'endcap=round')
end as link

FROM planet_osm_line 
WHERE highway is not null

Now we have created the buffer. Notice that for large roads the base size of our buffer is 18 meters, but for the smaller one it is 5 meters. Step 4 allowed us to use a case statement to make this happen. We name this buffer link, and only do it where highway is not null so that we are sure we are only buffering roads and paths.


