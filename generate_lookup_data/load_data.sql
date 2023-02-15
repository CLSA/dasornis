-- This file will load product and active ingredient data downloaded form the Health Canada Drug Product
-- Database (DPD)
-- @link http://www.hc-sc.gc.ca/dhp-mps/prodpharma/databasdon/dp_bdpp_data_extract-eng.php

SET CHARACTER SET 'utf8';
SET collation_connection = 'utf8_general_ci';

DROP TABLE IF EXISTS dp_therapeutic_class;
DROP TABLE IF EXISTS dp_active_ingredient;
DROP TABLE IF EXISTS dp_product;

source dp_product.sql
source dp_active_ingredient.sql
source dp_therapeutic_class.sql
source new_lookup_item.sql
source pine.sql
source drug_list.sql
