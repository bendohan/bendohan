--SQL code written by Benjamin Dohan and Robert Kelley

--correct errors in data table
update planet_osm_line set width = replace(width, 'O', '0') update planet_osm_line set width = trim(width, ' Mmetrs';

--turn width into a float variable by creating a new column for it
ALTER TABLE planet_osm_line ADD COLUMN nwidth float UPDATE planet_osm_line SET nwidth = CAST(width AS float) WHERE highway IS NOT NULL;

--set width of roads without width to be 0
UPDATE planet_osm_line SET nwidth = 0 WHERE highway IS NOT NULL AND nwidth is null;

--distinguish between large and small roads
ALTER TABLE planet_osm_line ADD COLUMN distinction integer UPDATE planet_osm_line SET distinction = 1 WHERE highway = 'trunk' or highway = 'trunk_link' or highway = 'primary' or highway = 'primary_link';

UPDATE planet_osm_line SET distinction = 0 WHERE highway = 'yes' OR highway = 'unclassified' OR highway = 'bridleway' OR highway = 'construction' OR highway = 'cycleway' OR highway = 'footway' OR highway = 'path' OR highway = 'pedestrian' OR highway = 'residential' Or highway= 'road' OR highway = 'secondary' OR highway = 'secondary_link' OR highway = 'service' OR highway = 'steps' OR highway = 'tertiary' Or highway = 'tertiary_link' OR highway = 'track';

--create the buffer around the roads
CREATE TABLE buffer7 as SELECT nwidth, distinction CASE WHEN distinction = 1 then ST_Buffer(Geography(way), 18+nwidth/2, 'endcap=round') when distinction = 0 then ST_Buffer(Geography(way), 5+nwidth/2, 'endcap=round') end as link FROM planet_osm_line WHERE highway is not null;

--create a new table with just the house polygons
create table home as SELECT building, amenity, way::geometry(4326, 'polygon') FROM planet_osm_polygon WHERE building = 'yes' AND amenity IS NULL OR building = 'residential';

--set new variable linkage to be equal to the distinction value of the buffer it intersects
ALTER table home ADD COLUMN linkage float update buffer7 set geom = link::geometry('polygon', 4326) UPDATE home set linkage = distinction FROM buffer7 WHERE st_intersects(way, geom);

--attach a subward fid to each house
UPDATE home SET subward = fid FROM subwardra WHERE ST_Intersects(way, ST_makeValid(geom));

--define houses as accessible or not accessible
ALTER table home add column access integer
UPDATE home set access = 1 WHERE linkage IS NOT NULL 
UPDATE home set access = 0 WHERE linkage IS NULL

--count the number of accessible homes and the number of total homes
create table acc as select subward, count(access) as acY from home WHERE access = 1 group by subward
create table total as select subward, count(access) as acY from home group by subward

--join the number of homes in each subward onto the subward layer
alter table subwardra add column allhomes2 float
update subwardra
set allhomes2 = acT FROM test5 WHERE acc.subward = subwardra.fid

--join the number of accessible homes in each subward onto the subward layer
alter table subwardra add column sherlockhomes2 float
update subwardra set sherlockhomes2 = acY FROM test6 WHERE total.subward = subwardra.fid

--calculate and store the percent of accessible homes in each subward
alter table home add column pctaccess float
update subwardra set pctaccess = (sherlockhomes/allhomes *100)

--create a table of points of healthcare options to make the map more interesting
create table health as
SELECT building, amenity, way FROM planet_osm_point where building = 'hospital' or amenity = 'hospital' or amenity = 'doctors' or building = 'doctors
