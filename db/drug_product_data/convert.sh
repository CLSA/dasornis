#!/bin/bash

for file in *.txt; do
  echo "Converting $file..."
  LC_ALL=C sed 's/ *[\x00-\x19\x7B\x7D-\xBF]\+ */ /g' $file |
    sed 's/ *" */"/g' |
    iconv -f iso-8859-1 -t UTF-8 > enc_$file
done
