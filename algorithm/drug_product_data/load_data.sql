-- This file will load all data downloaded form the Health Canada Drug Product Database (DPD)
-- @link http://www.hc-sc.gc.ca/dhp-mps/prodpharma/databasdon/dp_bdpp_data_extract-eng.php

SET CHARACTER SET 'utf8';
-- SET collation_connection = 'utf8_general_ci';

DROP TABLE IF EXISTS dp_active_ingredient;
DROP TABLE IF EXISTS dp_company;
DROP TABLE IF EXISTS dp_form;
DROP TABLE IF EXISTS dp_packaging;
DROP TABLE IF EXISTS dp_pharmaceutical_standard;
DROP TABLE IF EXISTS dp_route;
DROP TABLE IF EXISTS dp_schedule;
DROP TABLE IF EXISTS dp_status;
DROP TABLE IF EXISTS dp_therapeutic_class;
DROP TABLE IF EXISTS dp_product;

SOURCE dp_product.sql
SOURCE dp_company.sql
SOURCE dp_form.sql
SOURCE dp_active_ingredient.sql
SOURCE dp_packaging.sql
SOURCE dp_pharmaceutical_standard.sql
SOURCE dp_route.sql
SOURCE dp_schedule.sql
SOURCE dp_status.sql
SOURCE dp_therapeutic_class.sql

DELETE FROM dp_product WHERE class = "Veterinary";
