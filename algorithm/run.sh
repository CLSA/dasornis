#!/bin/bash

echo "##### PRE-PROCESSING #####"
echo

php preprocess.php

echo
echo "##### FINDING MATCHES #####"

mdb dasornis < match.sql
mdb dasornis < list_all.sql | sed -e 's/\t/","/g' | sed -e 's/.*/"&"/' | sed -e 's/"NULL"/""/g' > all.csv

echo
echo "Finished, results have been written to all.csv"
echo
