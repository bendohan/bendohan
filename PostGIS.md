## SQL GIS and online mapping:
## An interactive urban resilience excercise

This excercise is based around using Opensource data and GIS to measure Urban Resiliency. We will use data from Dar es Salaam, Tanzania, which is one of the best mapped regions on OpenStreetMap. This is a massive dataset, and so we will need to pick and choose what data we want to use, then isolate that data.

Our goal is to determine which houses are accessible by roads and paths and which are not. The gameplan is to create buffers around the roads that reach only the layer of houses that are adjacent to the roads. Those will be the houses which we determine to be accessible, and the other houses will be deemed inaccessible. Once you have the data, you can look through the attributes. We will be using the columns 'highway', 'width', 'building', and 'amenity'. You will also notice the data is extremely messy, and not everything is input the way we would want it to be. Our first steps will be to clean up the data a bit. We want the width column to function as an integer, but right now it is a string datatype. The main problems are that people entered data with 'm' or 'meters' at the end, and some data has O's where it should have 0's. We can solve this with two SQL lines:

update planet_osm_line set width = replace(width, 'O', '0') 

update planet_osm_line set width = trim(width, ' Mmetrs')

The first line here replaces any O's with zeros, and the second line removes anything after it detects an M. So, if a user entered a width value as '1o meters', it becomes '10'.
