#!/bin/bash

cd health_canada_drug_database
unzip -q hcdd.zip
mysql_db danorsis < load_data.sql
rm *.txt
cd ../input_data
mysql_db danorsis < load_data.sql
cd ..
mysql_db danorsis < initialize.sql
php preprocess.php
