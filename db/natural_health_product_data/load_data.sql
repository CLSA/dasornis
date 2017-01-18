-- This file will load all data downloaded form the Health Canada Natural and Non-prescription Health Products Directorate (NNHPD)
-- @link http://www.hc-sc.gc.ca/dhp-mps/prodnatur/applications/licen-prod/lnhpd-bdpsnh_data_extract-eng.php

DROP TABLE IF EXISTS nhp_purpose;
DROP TABLE IF EXISTS nhp_recommended_dose;
DROP TABLE IF EXISTS nhp_risk;
DROP TABLE IF EXISTS nhp_company;
DROP TABLE IF EXISTS nhp_medicinal_ingredient;
DROP TABLE IF EXISTS nhp_route;
DROP TABLE IF EXISTS nhp_nonmedicinal_ingredient;
DROP TABLE IF EXISTS nhp_name;
DROP TABLE IF EXISTS nhp_product;

source nhp_product.sql
source nhp_purpose.sql
source nhp_recommended_dose.sql
source nhp_risk.sql
source nhp_company.sql
source nhp_medicinal_ingredient.sql
source nhp_route.sql
source nhp_nonmedicinal_ingredient.sql
source nhp_name.sql
