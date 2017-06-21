#!/bin/bash
mysql_db dasornis < list_matches.sql | sed -e 's/\t/","/g' | sed -e 's/.*/"&"/' > matches.csv
