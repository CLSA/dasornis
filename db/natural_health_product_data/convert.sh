#!/bin/bash

for file in *.txt; do
  echo "Converting $file..."
  LC_ALL=C sed 's/ *[\x00-\x19\x7B\x7D-\xBF]\+ */ /g' $file |
    iconv -f iso-8859-1 -t UTF-8 |
    sed 's/"\(.*\)"/\1/;s/"|"/|/g;s/ *| */|/g' |
    sed "s/\`/'/g" |
    sed 's/_/ /g;s/\\/\//g;s/\[/(/g;s/\]/)/g;s/\*//g;s/=//g;s/</(/g;s/>/)/g;s/  \+/ /g;s/ *" */"/g' > enc_$file

done
