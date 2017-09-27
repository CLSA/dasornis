#!/bin/bash
mysql_db dasornis < list_matched.sql | sed -e 's/\t/","/g' | sed -e 's/.*/"&"/' > matched.csv
mysql_db dasornis < list_unmatched.sql | sed -e 's/\t/","/g' | sed -e 's/.*/"&"/' > unmatched.csv
