-- Q1. Airlines

-- You must not change the next 2 lines or the table definition.
SET SEARCH_PATH TO air_travel, public;
DROP TABLE IF EXISTS q1 CASCADE;

CREATE TABLE q1 (
    pass_id INT,
    name VARCHAR(100),
    airlines INT
);

-- Do this for each of the views that define your intermediate steps.  
-- (But give them better names!) The IF EXISTS avoids generating an error 
-- the first time this file is imported.

DROP VIEW IF EXISTS fullname CASCADE;
DROP VIEW IF EXISTS pass_airline CASCADE;

-- Define views for your intermediate steps here:

CREATE VIEW pass_airline AS
select pass_id, count(airline) as airlines
from booking,departure,flight
where booking.flight_id = departure.flight_id
and departure.flight_id = flight.id
group by pass_id;

CREATE VIEW fullname AS
SELECT id AS pass_id, concat(firstname, ' ', surname) AS name
FROM Passenger;


-- Your query that answers the question goes below the "insert into" line:
INSERT INTO q1
SELECT pass_id, name, COALESCE(airlines, 0)
FROM fullname NATURAL LEFT JOIN pass_airline

