#!/bin/bash

echo "Converting data..."
iconv -f iso-8859-1 -t UTF-8 data.csv -o enc_data.csv
