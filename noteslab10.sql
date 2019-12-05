--Created by Benjamin Dohan

--create a fill a geometry column for the dorian twitter data in EPSG 102004
SELECT AddGeometryColumn ('public','dorian','geom',102004,'POINT',2, false);
update dorian
set geom = st_transform(st_setsrid(st_makepoint(lng, lat), 4326), 102004)

--create and fill a geometry column for the baseline november twitter data in EPSG 102004
SELECT AddGeometryColumn ('public','november','geom',102004,'POINT',2, false);
update november
set geom = st_transform(st_setsrid(st_makepoint(lng, lat), 4326), 102004)

--change the counties geometry to be in 102004
UPDATE counties SET geometry = st_transform(geometry, 102004)
select populate_geometry_columns()

--delete all states that we are not interested in
DELETE FROM counties
WHERE statefp NOT IN ('54', '51', '50', '47', '45', '44', '42', '39', '37',
'36', '34', '33', '29', '28', '25', '24', '23', '22', '21', '18', '17',
'13', '12', '11', '10', '09', '05', '01');

--add a column to the november dataset
ALTER TABLE november ADD COLUMN geoid varchar(5)

--attach a county to each tweet location
Update november
set geoid = (select geoid from counties
Where st_intersects(geom, counties.geometry))

--add a geoid column to the dorian dataset
ALTER TABLE dorian ADD COLUMN geoid varchar(5)

--attached a county to each tweet location
Update dorian
set geoid = (select geoid from counties
Where st_intersects(geom, counties.geometry))

--count the number of tweets by county
SELECT COUNT(status_id)
FROM november
group by geoid

--create a new column in counties for november tweets
alter table counties
add column novtweets integer

--create a new column in counties for dorian tweets
alter table counties
add column doriantweets integer

--set novtweets to be 0
update counties
set novtweets = 0

--set novtweets to be equal to the number of november tweets per county
update counties
set novtweets =
(SELECT COUNT(status_id)
from november
WHERE november.geoid = counties.geoid
group by geoid)

--set dorian tweeets to be 0
update counties
set doriantweets = 0

--set dorian tweets to be equal to the number of dorian tweets per county
update counties
set doriantweets =
(SELECT COUNT(status_id)
from dorian
WHERE dorian.geoid = counties.geoid
group by geoid)

--set doriantweets to be 0 where dorian tweet is null
UPDATE counties
set doriantweets = 0 WHERE doriantweets is null
--set novtweets to be 0 where it is null
UPDATE counties
set novtweets = 0 WHERE novtweets is null

--add a new column to counties called tweetrate
alter table counties add column tweetrate real

--set tweetrate equal to the number of dorian tweets per 10,000 people
update counties
set tweetrate = (doriantweets/pop)*10000

--create a new column in counties called ndti
alter table counties add column ndti float

--set ndti to be a normalized tweet difference index, making sure to not divide by 0
update counties
set ndti = ((doriantweets-novtweets*1.0)/(doriantweets+novtweets)) 
WHERE doriantweets+novtweets >0

--set ndti to be equal to 0 where you otherwise would have divided by 0
update counties
set ndti = 0 WHERE ((doriantweets+novtweets) = 0)
create table countiescentroids as