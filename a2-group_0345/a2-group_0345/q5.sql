-- Q5. Flight Hopping

-- You must not change the next 2 lines or the table definition.
SET SEARCH_PATH TO air_travel, public;
DROP TABLE IF EXISTS q5 CASCADE;

CREATE TABLE q5 (
	destination CHAR(3),
	num_flights INT
);

-- Do this for each of the views that define your intermediate steps.  
-- (But give them better names!) The IF EXISTS avoids generating an error 
-- the first time this file is imported.
DROP VIEW IF EXISTS intermediate_step CASCADE;
DROP VIEW IF EXISTS day CASCADE;
DROP VIEW IF EXISTS n CASCADE;

CREATE VIEW day AS
SELECT day::date as day FROM q5_parameters;
-- can get the given date using: (SELECT day from day)

CREATE VIEW n AS
SELECT n FROM q5_parameters;
-- can get the given number of flights using: (SELECT n from n)

-- HINT: You can answer the question by writing one recursive query below, without any more views.
-- Your query that answers the question goes below the "insert into" line:
INSERT INTO q5 (with RECURSIVE ds(s_arv, inbound, num_flights, n) as 
	(select flight.s_arv, flight.inbound, 1 as num_flights, q5_parameters.n 
		from air_travel.flight, air_travel.q5_parameters 
		where date_trunc('day', flight.s_dep) = date_trunc('day', q5_parameters.day) 
		and q5_parameters.n >= 1 and flight.outbound = 'YYZ'
		 union all select flight.s_arv, flight.inbound, (ds.num_flights + 1) as num_flights, ds.n 
		 from ds, air_travel.flight 
		 where flight.s_dep >= ds.s_arv and ds.inbound = flight.outbound 
		 and (flight.s_dep - ds.s_arv) <= '24:00:00' and (ds.num_flights + 1) <= ds.n) 
	select inbound as destination, num_flights from ds)
















