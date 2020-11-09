--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.16
-- Dumped by pg_dump version 9.6.16

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Data for Name: Category; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO wetworldschema."Category" ("Id", "Name") VALUES ('c1', 'open water');
INSERT INTO wetworldschema."Category" ("Id", "Name") VALUES ('c2', 'cave');
INSERT INTO wetworldschema."Category" ("Id", "Name") VALUES ('c3', 'beyond 30 meters');


--
-- Data for Name: Monitor; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO wetworldschema."Monitor" ("Id", "Name", "Email") VALUES ('m1', 'Maria', 'maria@dm.org');
INSERT INTO wetworldschema."Monitor" ("Id", "Name", "Email") VALUES ('m2', 'John', 'john@dm.org');
INSERT INTO wetworldschema."Monitor" ("Id", "Name", "Email") VALUES ('m3', 'Ben', 'ben@dm.org');


--
-- Data for Name: Site; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO wetworldschema."Site" ("Id", "Name", "Location", "Capacity", "Fee") VALUES ('s1', 'Bloody Bay Marine Park', 'Little Cayman', 10, 10);
INSERT INTO wetworldschema."Site" ("Id", "Name", "Location", "Capacity", "Fee") VALUES ('s2', 'Widow Maker’s Cave', 'Montego Bay', 10, 20);
INSERT INTO wetworldschema."Site" ("Id", "Name", "Location", "Capacity", "Fee") VALUES ('s3', 'Crystal Bay', 'Crystal Bay', 10, 15);
INSERT INTO wetworldschema."Site" ("Id", "Name", "Location", "Capacity", "Fee") VALUES ('s4', 'Batu Bolong', 'Batu Bolong', 10, 15);


--
-- Data for Name: Privilege; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO wetworldschema."Privilege" ("Id", "MonitorId", "SiteId", "CategoryId", "Period", "Price", "MaxSize") VALUES ('p1', 'm1', 's1', 'c2', 'night', 25, 5);
INSERT INTO wetworldschema."Privilege" ("Id", "MonitorId", "SiteId", "CategoryId", "Period", "Price", "MaxSize") VALUES ('p7', 'm3', 's2', 'c2', 'morning', 20, 5);
INSERT INTO wetworldschema."Privilege" ("Id", "MonitorId", "SiteId", "CategoryId", "Period", "Price", "MaxSize") VALUES ('p6', 'm2', 's1', 'c2', 'morning', 15, 15);
INSERT INTO wetworldschema."Privilege" ("Id", "MonitorId", "SiteId", "CategoryId", "Period", "Price", "MaxSize") VALUES ('p5', 'm1', 's4', 'c2', 'morning', 30, 5);
INSERT INTO wetworldschema."Privilege" ("Id", "MonitorId", "SiteId", "CategoryId", "Period", "Price", "MaxSize") VALUES ('p3', 'm1', 's2', 'c2', 'morning', 20, 5);
INSERT INTO wetworldschema."Privilege" ("Id", "MonitorId", "SiteId", "CategoryId", "Period", "Price", "MaxSize") VALUES ('p2', 'm1', 's2', 'c1', 'morning', 10, 10);
INSERT INTO wetworldschema."Privilege" ("Id", "MonitorId", "SiteId", "CategoryId", "Period", "Price", "MaxSize") VALUES ('p4', 'm1', 's3', 'c1', 'afternoon', 15, 10);


--
-- Data for Name: Book; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO wetworldschema."Book" ("Id", "DiverId", "PrivilegeId", "DiveDate") VALUES ('b1', 'd1', 'p3', '2019-07-20');
INSERT INTO wetworldschema."Book" ("Id", "DiverId", "PrivilegeId", "DiveDate") VALUES ('b2', 'd1', 'p3', '2019-07-21');
INSERT INTO wetworldschema."Book" ("Id", "DiverId", "PrivilegeId", "DiveDate") VALUES ('b3', 'd1', 'p6', '2019-07-22');
INSERT INTO wetworldschema."Book" ("Id", "DiverId", "PrivilegeId", "DiveDate") VALUES ('b4', 'd1', 'p1', '2019-07-22');
INSERT INTO wetworldschema."Book" ("Id", "DiverId", "PrivilegeId", "DiveDate") VALUES ('b5', 'd5', 'p4', '2019-07-22');
INSERT INTO wetworldschema."Book" ("Id", "DiverId", "PrivilegeId", "DiveDate") VALUES ('b6', 'd5', 'p7', '2019-07-23');
INSERT INTO wetworldschema."Book" ("Id", "DiverId", "PrivilegeId", "DiveDate") VALUES ('b7', 'd5', 'p7', '2019-07-24');


--
-- Data for Name: Diver; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO wetworldschema."Diver" ("Id", "Name", "BirthDay", "Certification", "CreditCard", "Email") VALUES ('d1', 'Michael', '1967-03-15', 'PADI', '111111111', 'michael@dm.org');
INSERT INTO wetworldschema."Diver" ("Id", "Name", "BirthDay", "Certification", "CreditCard", "Email") VALUES ('d5', 'Andy', '1973-10-10', 'PADI', '555555555', 'andy@dm.org');
INSERT INTO wetworldschema."Diver" ("Id", "Name", "BirthDay", "Certification", "CreditCard", "Email") VALUES ('d2', 'Dwight Schrute', '1967-03-16', 'CMAS', '222222222', 'dwight@dm.org');
INSERT INTO wetworldschema."Diver" ("Id", "Name", "BirthDay", "Certification", "CreditCard", "Email") VALUES ('d3', 'Jim Halpert', '1967-03-17', 'CMAS', '333333333', 'jim@dm.org');
INSERT INTO wetworldschema."Diver" ("Id", "Name", "BirthDay", "Certification", "CreditCard", "Email") VALUES ('d4', 'Pam Beesly', '1967-03-17', 'NAUI', '444444444', 'pam@dm.org');
INSERT INTO wetworldschema."Diver" ("Id", "Name", "BirthDay", "Certification", "CreditCard", "Email") VALUES ('d6', 'Phyllis', '1973-10-11', 'NAUI', '666666666', 'phyllis@dm.org');
INSERT INTO wetworldschema."Diver" ("Id", "Name", "BirthDay", "Certification", "CreditCard", "Email") VALUES ('d7', 'Oscar', '1973-10-12', 'CMAS', '777777777', 'oscar@dm.org');


--
-- Data for Name: BookGroup; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO wetworldschema."BookGroup" ("BookId", "DiverId") VALUES ('b1', 'd1');
INSERT INTO wetworldschema."BookGroup" ("BookId", "DiverId") VALUES ('b1', 'd2');
INSERT INTO wetworldschema."BookGroup" ("BookId", "DiverId") VALUES ('b1', 'd3');
INSERT INTO wetworldschema."BookGroup" ("BookId", "DiverId") VALUES ('b1', 'd4');
INSERT INTO wetworldschema."BookGroup" ("BookId", "DiverId") VALUES ('b1', 'd5');
INSERT INTO wetworldschema."BookGroup" ("BookId", "DiverId") VALUES ('b2', 'd1');
INSERT INTO wetworldschema."BookGroup" ("BookId", "DiverId") VALUES ('b2', 'd2');
INSERT INTO wetworldschema."BookGroup" ("BookId", "DiverId") VALUES ('b2', 'd3');
INSERT INTO wetworldschema."BookGroup" ("BookId", "DiverId") VALUES ('b3', 'd1');
INSERT INTO wetworldschema."BookGroup" ("BookId", "DiverId") VALUES ('b3', 'd3');
INSERT INTO wetworldschema."BookGroup" ("BookId", "DiverId") VALUES ('b4', 'd1');
INSERT INTO wetworldschema."BookGroup" ("BookId", "DiverId") VALUES ('b5', 'd5');
INSERT INTO wetworldschema."BookGroup" ("BookId", "DiverId") VALUES ('b5', 'd2');
INSERT INTO wetworldschema."BookGroup" ("BookId", "DiverId") VALUES ('b5', 'd3');
INSERT INTO wetworldschema."BookGroup" ("BookId", "DiverId") VALUES ('b5', 'd4');
INSERT INTO wetworldschema."BookGroup" ("BookId", "DiverId") VALUES ('b5', 'd1');


--
-- Data for Name: MonitorRate; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO wetworldschema."MonitorRate" ("BookId", "DiverId", "Rate") VALUES ('b1', 'd1', 2);
INSERT INTO wetworldschema."MonitorRate" ("BookId", "DiverId", "Rate") VALUES ('b2', 'd1', 0);
INSERT INTO wetworldschema."MonitorRate" ("BookId", "DiverId", "Rate") VALUES ('b3', 'd1', 5);
INSERT INTO wetworldschema."MonitorRate" ("BookId", "DiverId", "Rate") VALUES ('b5', 'd5', 1);
INSERT INTO wetworldschema."MonitorRate" ("BookId", "DiverId", "Rate") VALUES ('b6', 'd5', 0);
INSERT INTO wetworldschema."MonitorRate" ("BookId", "DiverId", "Rate") VALUES ('b7', 'd5', 2);


--
-- Data for Name: Provide; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO wetworldschema."Provide" ("SiteId", "ItemName", "Fee") VALUES ('s1', 'mask', 5);
INSERT INTO wetworldschema."Provide" ("SiteId", "ItemName", "Fee") VALUES ('s1', 'fin', 10);
INSERT INTO wetworldschema."Provide" ("SiteId", "ItemName", "Fee") VALUES ('s2', 'mask', 3);
INSERT INTO wetworldschema."Provide" ("SiteId", "ItemName", "Fee") VALUES ('s2', 'fin', 5);
INSERT INTO wetworldschema."Provide" ("SiteId", "ItemName", "Fee") VALUES ('s3', 'fin', 5);
INSERT INTO wetworldschema."Provide" ("SiteId", "ItemName", "Fee") VALUES ('s3', 'wrist-mounted dive computer', 20);
INSERT INTO wetworldschema."Provide" ("SiteId", "ItemName", "Fee") VALUES ('s4', 'mask', 10);
INSERT INTO wetworldschema."Provide" ("SiteId", "ItemName", "Fee") VALUES ('s4', 'wrist-mounted dive computer', 30);


--
-- Data for Name: SiteRate; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO wetworldschema."SiteRate" ("SiteId", "DiverId", "Rate") VALUES ('s1', 'd3', 3);
INSERT INTO wetworldschema."SiteRate" ("SiteId", "DiverId", "Rate") VALUES ('s2', 'd2', 0);
INSERT INTO wetworldschema."SiteRate" ("SiteId", "DiverId", "Rate") VALUES ('s2', 'd4', 1);
INSERT INTO wetworldschema."SiteRate" ("SiteId", "DiverId", "Rate") VALUES ('s2', 'd3', 2);
INSERT INTO wetworldschema."SiteRate" ("SiteId", "DiverId", "Rate") VALUES ('s3', 'd5', 4);
INSERT INTO wetworldschema."SiteRate" ("SiteId", "DiverId", "Rate") VALUES ('s3', 'd4', 5);
INSERT INTO wetworldschema."SiteRate" ("SiteId", "DiverId", "Rate") VALUES ('s3', 'd1', 2);
INSERT INTO wetworldschema."SiteRate" ("SiteId", "DiverId", "Rate") VALUES ('s3', 'd7', 3);


--
-- PostgreSQL database dump complete
--

