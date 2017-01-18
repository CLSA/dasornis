-- This file will load all data downloaded form the Health Canada Drug Product Database (DPD)
-- @link http://www.hc-sc.gc.ca/dhp-mps/prodpharma/databasdon/dp_bdpp_data_extract-eng.php

DROP TABLE IF EXISTS dp_active_ingredient;
DROP TABLE IF EXISTS dp_company;
DROP TABLE IF EXISTS dp_form;
DROP TABLE IF EXISTS dp_packaging;
DROP TABLE IF EXISTS dp_pharmaceutical_standard;
DROP TABLE IF EXISTS dp_route;
DROP TABLE IF EXISTS dp_schedule;
DROP TABLE IF EXISTS dp_status;
DROP TABLE IF EXISTS dp_therapeutic_class;
DROP TABLE IF EXISTS dp_veterinary_species;
DROP TABLE IF EXISTS dp_product;

source dp_product.sql
source dp_company.sql
source dp_form.sql
source dp_active_ingredient.sql
source dp_packaging.sql
source dp_pharmaceutical_standard.sql
source dp_route.sql
source dp_schedule.sql
source dp_status.sql
source dp_therapeutic_class.sql
source dp_veterinary_species.sql
