#!/bin/bash

# The following doesn't typically need to be done every time so leaving it commented out
# echo "Loading data..."
# dir_list=(drug_product_data input_data lnhpd_product_data manual_match_data nhp_product_data pre_match_data word_correction_data)
# 
# for dir in "${dir_list[@]}"; do
#   cd $dir
#   ./convert.sh
#   mdb dasornis < load_data.sql
#   exit 1
#   cd ..
# done

echo "##### PRE-PROCESSING #####"
echo
php preprocess.php

echo
echo "##### FINDING MATCHES #####"
mdb dasornis < match.sql

mdb dasornis < list_all.sql | sed -e 's/\t/","/g' | sed -e 's/.*/"&"/' | sed -e 's/"NULL"/""/g' > all.csv
# mdb dasornis < list_matched.sql | sed -e 's/\t/","/g' | sed -e 's/.*/"&"/' | sed -e 's/"NULL"/""/g' > matched.csv
# mdb dasornis < list_unmatched.sql | sed -e 's/\t/","/g' | sed -e 's/.*/"&"/' | sed -e 's/"NULL"/""/g' > unmatched.csv

echo
echo "Finished, results have been written to all.csv"
echo
