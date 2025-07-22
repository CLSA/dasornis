SELECT data.identifier, REPLACE( data.input, '"', '""' ) AS input
FROM data
LEFT JOIN data_has_din USING( identifier )
LEFT JOIN data_has_npn USING( identifier )
WHERE din IS NULL
  AND npn IS NULL
ORDER BY identifier;
