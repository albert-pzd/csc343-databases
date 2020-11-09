-- Q4. Plane Capacity Histogram

-- You must not change the next 2 lines or the table definition.
SET SEARCH_PATH TO air_travel, public;
DROP TABLE IF EXISTS q4 CASCADE;

CREATE TABLE q4 (
	airline CHAR(2),
	tail_number CHAR(5),
	very_low INT,
	low INT,
	fair INT,
	normal INT,
	high INT
);

-- Do this for each of the views that define your intermediate steps.  
-- (But give them better names!) The IF EXISTS avoids generating an error 
-- the first time this file is imported.
DROP VIEW IF EXISTS intermediate_step CASCADE;


-- Define views for your intermediate steps here:


-- Your query that answers the question goes below the "insert into" line:
INSERT INTO q4 (with fcap as (select flight_id, count(flight_id)  
	from air_travel.booking 
	where flight_id in (select flight_id from air_travel.departure) 
	group by flight_id), 
pl as (select airline, plane as tail_number, id as flight_id from air_travel.flight), 
pfc as (select pl.airline, pl.tail_number, pl.flight_id, fcap.count 
	from pl join fcap on pl.flight_id = fcap.flight_id), 
al as (select plane.airline, plane.tail_number, pfc.flight_id, 
	pfc.count::numeric/(plane.capacity_economy + plane.capacity_business + plane.capacity_first)::numeric 
	as per 
	from air_travel.plane 
	left join pfc on plane.tail_number = pfc.tail_number 
	and plane.airline = pfc.airline) 
select airline, tail_number,count(flight_id) 
filter (where per >=0.0 and per <= 0.2) as very_low, 
count(flight_id) filter (where per >0.2 and per <= 0.4) as low, 
count(flight_id) filter (where per >0.4 and per <= 0.6) as fair,
count(flight_id) filter (where per >0.6 and per <= 0.8) as normal,
count(flight_id) filter (where per >0.8) as high from al group by airline, tail_number)
