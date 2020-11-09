-- Q3. North and South Connections

-- You must not change the next 2 lines or the table definition.
SET SEARCH_PATH TO air_travel, public;
DROP TABLE IF EXISTS q3 CASCADE;

CREATE TABLE q3 (
    outbound VARCHAR(30),
    inbound VARCHAR(30),
    direct INT,
    one_con INT,
    two_con INT,
    earliest timestamp
);

-- Do this for each of the views that define your intermediate steps.  
-- (But give them better names!) The IF EXISTS avoids generating an error 
-- the first time this file is imported.
DROP VIEW IF EXISTS flight_april CASCADE;
DROP VIEW IF EXISTS outbound_airport CASCADE;
DROP VIEW IF EXISTS usa_can CASCADE;
DROP VIEW IF EXISTS canada_city_airport CASCADE;
DROP VIEW IF EXISTS usa_city_airport CASCADE;
DROP VIEW IF EXISTS usa_can CASCADE;
DROP VIEW IF EXISTS direct_route CASCADE;
DROP VIEW IF EXISTS num_direct_route CASCADE;
DROP VIEW IF EXISTS one_connection CASCADE;
DROP VIEW IF EXISTS one_connection_inter CASCADE;
DROP VIEW IF EXISTS num_one_connection CASCADE;
DROP VIEW IF EXISTS two_connection CASCADE;
DROP VIEW IF EXISTS num_two_connection CASCADE;
DROP VIEW IF EXISTS two_connection_inter CASCADE;
DROP VIEW IF EXISTS combinations CASCADE;
DROP VIEW IF EXISTS t1 CASCADE;
DROP VIEW IF EXISTS t2 CASCADE;
DROP VIEW IF EXISTS t3 CASCADE;

-- Define views for your intermediate steps here:

CREATE VIEW flight_april as 
select outbound, inbound, s_dep, s_arv from flight
where date_trunc('day', s_dep) = TIMESTAMP '2020-04-30'
and date_trunc('day', s_arv) = TIMESTAMP '2020-04-30';

CREATE VIEW outbound_airport as 
select outbound, inbound, s_dep, s_arv, country as out_country, city as out_city
from flight_april join airport ON outbound = code
where country in ('Canada', 'USA');

CREATE VIEW canada_city_airport as
select code, city, country
from airport
where airport.country = 'Canada';

CREATE VIEW usa_city_airport as
select code, city, country
from airport
where airport.country = 'USA';

CREATE VIEW usa_can as 
select *
from (select * from canada_city_airport UNION ALL select * from usa_city_airport) c;

CREATE VIEW combinations as
select c1.city as city1, c2.city as city2
from usa_can c1, usa_can c2
where c1.city != c2.city
and c1.country != c2.country
group by city1, city2;

CREATE VIEW direct_route as
select outbound, inbound, out_country, country as in_country, out_city, city as in_city, s_dep, s_arv
from outbound_airport join airport ON inbound = code
where country in ('Canada', 'USA');

CREATE VIEW direct_route_inter as
select *
from direct_route
where in_country != out_country;

CREATE VIEW num_direct_route as
select out_city, in_city, count(*) as direct, min(s_arv)
from direct_route_inter
group by out_city, in_city;

CREATE VIEW one_connection as
select outbound_airport.outbound as first_outbound, 
	direct_route.inbound as first_inbound, direct_route.in_country, outbound_airport.out_country, outbound_airport.out_city, direct_route.in_city, direct_route.s_arv, outbound_airport.s_dep
from outbound_airport, direct_route
where outbound_airport.inbound = direct_route.outbound
and direct_route.s_dep - outbound_airport.s_arv >= '00:30:00';

CREATE VIEW one_connection_inter as
select * from one_connection
where in_country != out_country;

CREATE VIEW num_one_connection as
select out_city, in_city, count(*) as one_con, min(s_arv)
from one_connection_inter
group by out_city, in_city;

CREATE VIEW two_connection as
select outbound_airport.outbound as second_outbound, 
	one_connection.first_inbound as second_inbound, one_connection.in_country, outbound_airport.out_country, outbound_airport.out_city, one_connection.in_city, one_connection.s_arv
from outbound_airport, one_connection
where outbound_airport.inbound = one_connection.first_outbound
and one_connection.s_dep - outbound_airport.s_arv >= '00:30:00';

CREATE VIEW two_connection_inter as
select * from two_connection
where in_country != out_country;

CREATE VIEW num_two_connection as
select out_city, in_city, count(*) as two_con, min(s_arv)
from two_connection_inter
group by out_city, in_city;

CREATE VIEW t1 as
select city1, city2, direct, min as min1
from  combinations LEFT JOIN num_direct_route ON combinations.city1 = num_direct_route.out_city
and combinations.city2 = num_direct_route.in_city;

CREATE VIEW t2 as
select city1, city2, one_con, direct, min as min2,min1
from  t1 LEFT JOIN num_one_connection ON t1.city1 = num_one_connection.out_city
and t1.city2 = num_one_connection.in_city;

CREATE VIEW t3 as
select city1 as outbound, city2 as inbound, direct, one_con, two_con, min as min3, min1, min2
from  t2 LEFT JOIN num_two_connection ON t2.city1 = num_two_connection.out_city
and t2.city2 = num_two_connection.in_city;



-- Your query that answers the question goes below the "insert into" line:
INSERT INTO q3
select outbound, inbound, COALESCE(direct, 0) as direct, COALESCE(one_con, 0) as one_con, COALESCE(two_con, 0) as two_con, LEAST(min1,min2,min3) as earliest
from t3;











