DROP TABLE IF EXISTS drug_list;
CREATE TABLE drug_list
SELECT
  identifier,
  new_lookup_item.name,
  new_lookup_item.description,
  GROUP_CONCAT( indicator.name ),
  lookup_item.id IS NULL AS new_drug
FROM new_lookup_item
LEFT JOIN lookup_item USING (identifier)
LEFT JOIN indicator_has_lookup_item ON lookup_item.id = indicator_has_lookup_item.lookup_item_id
LEFT JOIN indicator ON indicator_has_lookup_item.indicator_id = indicator.id
WHERE lookup_item.id IS NOT NULL OR new_lookup_item.status IN ( "approved", "marketed" )
GROUP BY identifier
ORDER BY identifier;
