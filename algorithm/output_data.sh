#!/bin/bash
mdb dasornis < list_all.sql | sed -e 's/\t/","/g' | sed -e 's/.*/"&"/' | sed -e 's/"NULL"/""/g' > all.csv
mdb dasornis < list_matched.sql | sed -e 's/\t/","/g' | sed -e 's/.*/"&"/' | sed -e 's/"NULL"/""/g' > matched.csv
mdb dasornis < list_unmatched.sql | sed -e 's/\t/","/g' | sed -e 's/.*/"&"/' | sed -e 's/"NULL"/""/g' > unmatched.csv
