-- Q2. Refunds!

-- You must not change the next 2 lines or the table definition.
SET SEARCH_PATH TO air_travel, public;
DROP TABLE IF EXISTS q2 CASCADE;

CREATE TABLE q2 (
    airline CHAR(2),
    name VARCHAR(50),
    year CHAR(4),
    seat_class seat_class,
    refund REAL
);

-- Do this for each of the views that define your intermediate steps.  
-- (But give them better names!) The IF EXISTS avoids generating an error 
-- the first time this file is imported.

DROP VIEW IF EXISTS flights_time CASCADE;
DROP VIEW IF EXISTS out_flights CASCADE;
DROP VIEW IF EXISTS in_flights CASCADE;
DROP VIEW IF EXISTS flights_inter CASCADE;
DROP VIEW IF EXISTS flights_refund CASCADE;
DROP VIEW IF EXISTS refund_inter CASCADE;


-- Define views for your intermediate steps here:

CREATE VIEW flights_time AS
select flight.id, departure.datetime - s_dep as dif_dep, 
	arrival.datetime - s_arv as dif_arv, airline, s_dep
from flight, departure, arrival
where flight.id = departure.flight_id
and departure.flight_id = arrival.flight_id;

CREATE VIEW flights_refund AS
select *
from flights_time
where dif_arv > 0.5 * dif_dep
and dif_dep >= '04:00:00';

CREATE VIEW out_flights AS
select flight.id, country as outcountry
from flight, airport
where flight.outbound = airport.code;

CREATE VIEW in_flights AS
select flight.id, country as incountry
from flight, airport
where flight.inbound = airport.code;

CREATE VIEW flights_inter AS
select out_flights.id, CASE WHEN outcountry = incountry 
	THEN 'DOMESTIC' ELSE 'INTERNATIONAL' END as global	
from out_flights, in_flights
where out_flights.id = in_flights.id;

CREATE VIEW refund_inter AS
select flight_id,  seat_class, CASE 
	WHEN dif_dep >= '10:00:00' and global = 'DOMESTIC' THEN price * 0.50
	WHEN dif_dep >= '12:00:00' and global = 'INTERNAIONAL' THEN price * 0.50
	WHEN dif_dep < '10:00:00' and global = 'DOMESTIC' THEN price * 0.35 
	WHEN dif_dep < '12:00:00' and global = 'INTERNATIONAL' THEN price * 0.35 END as refund, airline, airline.name, date_part('year', s_dep) as year
from flights_inter, flights_refund, booking, airline
where flights_inter.id = flights_refund.id
and flights_inter.id = booking.flight_id
and airline.code = airline;


-- Your query that answers the question goes below the "insert into" line:
INSERT INTO q2
select airline, name, year, seat_class, sum(refund)
from refund_inter
group by seat_class, airline, name, year;



