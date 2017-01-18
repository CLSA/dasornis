-- This file will load all data downloaded form the health canada drug database
-- @author Patrick Emond <emondpd@mcamster.ca>
-- @date 2016-12-14

SELECT "Dropping existing tables" AS "";

DROP TABLE IF EXISTS data;
DROP TABLE IF EXISTS active_ingredients;
DROP TABLE IF EXISTS companies;
DROP TABLE IF EXISTS form;
DROP TABLE IF EXISTS packaging;
DROP TABLE IF EXISTS pharmaceutical_std;
DROP TABLE IF EXISTS route;
DROP TABLE IF EXISTS schedule;
DROP TABLE IF EXISTS status;
DROP TABLE IF EXISTS therapeutic_class;
DROP TABLE IF EXISTS veterinary_species;

DROP TABLE IF EXISTS drug_product;

source drug.sql

source comp.sql
source form.sql
source ingred.sql
source package.sql
source pharm.sql
source route.sql
source schedule.sql
source status.sql
source ther.sql
source vet.sql
