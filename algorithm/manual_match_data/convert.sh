#!/bin/bash

echo "Converting data..."
LC_ALL=C sed 's/ *[\x00-\x19\x7B\x7D-\xBF]\+ */ /g' manual_match.csv |
  iconv -f iso-8859-1 -t UTF-8 |
  sed 's/ *" */"/g' > enc_manual_match.csv
