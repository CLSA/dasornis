#!/bin/bash
mysql_db dasornis < list_matched.sql | sed -e 's/\t/","/g' | sed -e 's/.*/"&"/' > matched.csv
mysql_db dasornis < list_unmatched.sql | sed -e 's/\t/","/g' | sed -e 's/.*/"&"/' > unmatched.csv
mysql_db dasornis < list_distinct_single_matched.sql | sed -e 's/\t/","/g' | sed -e 's/.*/"&"/' > distinct_single_matched.csv
mysql_db dasornis < list_distinct_multiple_matched.sql | sed -e 's/\t/","/g' | sed -e 's/.*/"&"/' > distinct_multiple_matched.csv
