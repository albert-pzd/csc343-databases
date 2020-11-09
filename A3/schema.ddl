drop schema if exists wetworldschema cascade;
create schema wetworldschema;
set search_path to wetworldschema;

-- Table: wetworldschema."Site"

-- DROP TABLE wetworldschema."Site";

CREATE TABLE wetworldschema."Site"
(
  "Id" character varying NOT NULL,
  "Name" character varying NOT NULL,
  "Location" character varying,
  "Capacity" integer NOT NULL,
  "Fee" integer NOT NULL,
  CONSTRAINT "Site_pkey" PRIMARY KEY ("Id")
)
WITH (
  OIDS=FALSE
);
ALTER TABLE wetworldschema."Site"
  OWNER TO postgres;

-- Table: wetworldschema."Category"

-- DROP TABLE wetworldschema."Category";

CREATE TABLE wetworldschema."Category"
(
  "Id" character varying NOT NULL,
  "Name" character varying NOT NULL,
  CONSTRAINT "Category_Id_pkey" PRIMARY KEY ("Id")
)
WITH (
  OIDS=FALSE
);
ALTER TABLE wetworldschema."Category"
  OWNER TO postgres;
  
  
-- Table: wetworldschema."Monitor"

-- DROP TABLE wetworldschema."Monitor";

CREATE TABLE wetworldschema."Monitor"
(
  "Id" character varying NOT NULL,
  "Name" character varying NOT NULL,
  "Email" character varying,
  CONSTRAINT "Monitor_pkey" PRIMARY KEY ("Id")
)
WITH (
  OIDS=FALSE
);
ALTER TABLE wetworldschema."Monitor"
  OWNER TO postgres;
  
-- Table: wetworldschema."Diver"

-- DROP TABLE wetworldschema."Diver";

CREATE TABLE wetworldschema."Diver"
(
  "Id" character varying NOT NULL,
  "Name" character varying NOT NULL,
  "BirthDay" date NOT NULL,
  "Certification" character varying NOT NULL,
  "CreditCard" character varying NOT NULL,
  "Email" character varying,
  CONSTRAINT "Diver_pkey" PRIMARY KEY ("Id")
)
WITH (
  OIDS=FALSE
);
ALTER TABLE wetworldschema."Diver"
  OWNER TO postgres;

-- Table: wetworldschema."Provide"

-- DROP TABLE wetworldschema."Provide";

CREATE TABLE wetworldschema."Provide"
(
  "SiteId" character varying NOT NULL,
  "ItemName" character varying NOT NULL,
  "Fee" integer,
  CONSTRAINT "Provide_pkey" PRIMARY KEY ("SiteId", "ItemName"),
  CONSTRAINT "Provide_SiteId_fkey" FOREIGN KEY ("SiteId")
      REFERENCES wetworldschema."Site" ("Id") MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE wetworldschema."Provide"
  OWNER TO postgres;

-- Table: wetworldschema."Privilege"

-- DROP TABLE wetworldschema."Privilege";

CREATE TABLE wetworldschema."Privilege"
(
  "Id" character varying NOT NULL,
  "MonitorId" character varying NOT NULL,
  "SiteId" character varying NOT NULL,
  "CategoryId" character varying NOT NULL,
  "Period" character varying NOT NULL,
  "Price" integer,
  "MaxSize" integer,
  CONSTRAINT "Privilege_pkey" PRIMARY KEY ("Id"),
  CONSTRAINT "Privilege_CategoryId_fkey" FOREIGN KEY ("CategoryId")
      REFERENCES wetworldschema."Category" ("Id") MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "Privilege_MonitorId_fkey" FOREIGN KEY ("MonitorId")
      REFERENCES wetworldschema."Monitor" ("Id") MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "Privilege_SiteId_fkey" FOREIGN KEY ("SiteId")
      REFERENCES wetworldschema."Site" ("Id") MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE wetworldschema."Privilege"
  OWNER TO postgres;

-- Index: wetworldschema."fki_Privilege_CategoryId_fkey"

-- DROP INDEX wetworldschema."fki_Privilege_CategoryId_fkey";

CREATE INDEX "fki_Privilege_CategoryId_fkey"
  ON wetworldschema."Privilege"
  USING btree
  ("CategoryId" COLLATE pg_catalog."default");

-- Index: wetworldschema."fki_Privilege_SiteId_fkey"

-- DROP INDEX wetworldschema."fki_Privilege_SiteId_fkey";

CREATE INDEX "fki_Privilege_SiteId_fkey"
  ON wetworldschema."Privilege"
  USING btree
  ("SiteId" COLLATE pg_catalog."default");



-- Table: wetworldschema."Book"

-- DROP TABLE wetworldschema."Book";

CREATE TABLE wetworldschema."Book"
(
  "Id" character varying NOT NULL,
  "DiverId" character varying NOT NULL,
  "PrivilegeId" character varying NOT NULL,
  "DiveDate" date,
  CONSTRAINT "Book_pkey" PRIMARY KEY ("Id"),
  CONSTRAINT "Book_PrivilegeId_fkey" FOREIGN KEY ("PrivilegeId")
      REFERENCES wetworldschema."Privilege" ("Id") MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE wetworldschema."Book"
  OWNER TO postgres;

-- Index: wetworldschema."fki_Book_DiverId_fkey"

-- DROP INDEX wetworldschema."fki_Book_DiverId_fkey";

CREATE INDEX "fki_Book_DiverId_fkey"
  ON wetworldschema."Book"
  USING btree
  ("DiverId" COLLATE pg_catalog."default");

-- Index: wetworldschema."fki_Book_PrivilegeId_fkey"

-- DROP INDEX wetworldschema."fki_Book_PrivilegeId_fkey";

CREATE INDEX "fki_Book_PrivilegeId_fkey"
  ON wetworldschema."Book"
  USING btree
  ("PrivilegeId" COLLATE pg_catalog."default");

-- Table: wetworldschema."BookGroup"

-- DROP TABLE wetworldschema."BookGroup";

CREATE TABLE wetworldschema."BookGroup"
(
  "BookId" character varying NOT NULL,
  "DiverId" character varying NOT NULL,
  CONSTRAINT "BookGroup_pkey" PRIMARY KEY ("BookId", "DiverId"),
  CONSTRAINT "BookGroup_BookId_fkey" FOREIGN KEY ("BookId")
      REFERENCES wetworldschema."Book" ("Id") MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "BookGroup_DiverId_fkey" FOREIGN KEY ("DiverId")
      REFERENCES wetworldschema."Diver" ("Id") MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE wetworldschema."BookGroup"
  OWNER TO postgres;

-- Table: wetworldschema."SiteRate"

-- DROP TABLE wetworldschema."SiteRate";

CREATE TABLE wetworldschema."SiteRate"
(
  "SiteId" character varying NOT NULL,
  "DiverId" character varying NOT NULL,
  "Rate" integer,
  CONSTRAINT "SiteRate_pkey" PRIMARY KEY ("SiteId", "DiverId"),
  CONSTRAINT "SiteRate_DiverId_fkey" FOREIGN KEY ("DiverId")
      REFERENCES wetworldschema."Diver" ("Id") MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "SiteRate_SiteId_fkey" FOREIGN KEY ("SiteId")
      REFERENCES wetworldschema."Site" ("Id") MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE wetworldschema."SiteRate"
  OWNER TO postgres;

-- Index: wetworldschema."fki_SiteRate_DiverId_fkey"

-- DROP INDEX wetworldschema."fki_SiteRate_DiverId_fkey";

CREATE INDEX "fki_SiteRate_DiverId_fkey"
  ON wetworldschema."SiteRate"
  USING btree
  ("DiverId" COLLATE pg_catalog."default");

-- Table: wetworldschema."MonitorRate"

-- DROP TABLE wetworldschema."MonitorRate";

CREATE TABLE wetworldschema."MonitorRate"
(
  "BookId" character varying NOT NULL,
  "DiverId" character varying NOT NULL,
  "Rate" integer,
  CONSTRAINT "MonitorRate_pkey" PRIMARY KEY ("BookId"),
  CONSTRAINT "MonitorRate_BookId_fkey" FOREIGN KEY ("BookId")
      REFERENCES wetworldschema."Book" ("Id") MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "MonitorRate_DiverId_fkey" FOREIGN KEY ("DiverId")
      REFERENCES wetworldschema."Diver" ("Id") MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE wetworldschema."MonitorRate"
  OWNER TO postgres;

-- Index: wetworldschema."fki_MonitorRate_DiverId_fkey"

-- DROP INDEX wetworldschema."fki_MonitorRate_DiverId_fkey";

CREATE INDEX "fki_MonitorRate_DiverId_fkey"
  ON wetworldschema."MonitorRate"
  USING btree
  ("DiverId" COLLATE pg_catalog."default");