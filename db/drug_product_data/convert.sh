#!/bin/bash

for file in *.txt; do
  echo "Converting $file..."
  iconv -f iso-8859-1 -t UTF-8 $file -o enc_$file
done
