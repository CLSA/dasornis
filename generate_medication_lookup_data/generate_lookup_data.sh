#!/bin/bash

mysql patrick_sandbox -e '
  SELECT id INTO @lookup_id FROM patrick_pine.lookup WHERE name = "medications";
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
  FROM patrick_pine.lookup_item
  JOIN new_lookup_item USING (identifier)
  LEFT JOIN patrick_pine.indicator_has_lookup_item ON lookup_item.id = lookup_item_id
  LEFT JOIN patrick_pine.indicator ON indicator_id = indicator.id
  WHERE lookup_item.lookup_id = @lookup_id
  GROUP BY identifier
  ORDER BY identifier;
' | sed -e 's#\t#","#g' | sed -e 's#.*#"&"#' | sed -e 's#"NULL"#""#g' > existing.csv

mysql patrick_sandbox -e '
  SELECT id INTO @lookup_id FROM patrick_pine.lookup WHERE name = "medications";
  SELECT
    new_lookup_item.identifier AS DIN,
    new_lookup_item.status,
    new_lookup_item.last_update_date,
    new_lookup_item.name,
    new_lookup_item.description,
    aig,
    atc_number AS "atc_number(s)",
    atc AS "atc(s)"
  FROM new_lookup_item
  LEFT JOIN patrick_pine.lookup_item ON lookup_item.lookup_id = @lookup_id
        AND new_lookup_item.identifier = lookup_item.identifier
  WHERE lookup_item.id IS NULL
  AND new_lookup_item.status IN ( "approved", "marketed" );
' | sed -e 's#\t#","#g' | sed -e 's#.*#"&"#' | sed -e 's#"NULL"#""#g' > new.csv

# mysql patrick_sandbox -e '
#   SELECT id INTO @lookup_id FROM patrick_pine.lookup WHERE name = "medications";
#   SELECT
#     lookup_item.identifier AS DIN,
#     lookup_item.name,
#     lookup_item.description
#   FROM patrick_pine.lookup_item
#   LEFT JOIN new_lookup_item USING (identifier)
#   WHERE lookup_item.lookup_id = @lookup_id
#   AND new_lookup_item.id IS NULL;
# ' | sed -e 's#\t#","#g' | sed -e 's#.*#"&"#' | sed -e 's#"NULL"#""#' > defunct.csv
