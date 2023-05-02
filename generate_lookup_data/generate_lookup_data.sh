#!/bin/bash

mysql patrick_sandbox -e '
  SELECT
    identifier AS DIN,
    status,
    lookup_item.name,
    IF( lookup_item.name = new_lookup_item.name, "", new_lookup_item.name ) AS "new name",
    lookup_item.description,
    IF( lookup_item.description = new_lookup_item.description, "", new_lookup_item.description ) AS "new description",
    aig,
    atc_number AS "atc_number(s)",
    atc AS "atc(s)",
    GROUP_CONCAT( indicator.name ORDER BY indicator.name SEPARATOR ";" ) AS "indicator(s)"
  FROM lookup_item
  JOIN new_lookup_item USING (identifier)
  LEFT JOIN indicator_has_lookup_item ON lookup_item.id = lookup_item_id
  LEFT JOIN indicator ON indicator_id = indicator.id
  GROUP BY identifier
  ORDER BY identifier
' | sed -e 's#\t#","#g' | sed -e 's#.*#"&"#' | sed -e 's#"NULL"#""#g' > existing.csv

mysql patrick_sandbox -e '
  SELECT
    new_lookup_item.identifier AS DIN,
    new_lookup_item.status,
    new_lookup_item.name,
    new_lookup_item.description,
    aig,
    atc_number AS "atc_number(s)",
    atc AS "atc(s)"
  FROM new_lookup_item
  LEFT JOIN lookup_item USING (identifier)
  WHERE lookup_item.id IS NULL
  AND new_lookup_item.status IN ( "approved", "marketed" )
' | sed -e 's#\t#","#g' | sed -e 's#.*#"&"#' | sed -e 's#"NULL"#""#g' > new.csv

# mysql patrick_sandbox -e '
#   SELECT
#     lookup_item.identifier AS DIN,
#     lookup_item.name,
#     lookup_item.description
#   FROM lookup_item
#   LEFT JOIN new_lookup_item USING (identifier)
#   where new_lookup_item.id IS NULL
# ' | sed -e 's#\t#","#g' | sed -e 's#.*#"&"#' | sed -e 's#"NULL"#""#' > defunct.csv
