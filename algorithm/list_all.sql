SELECT data.identifier,
       REPLACE( data.input, '"', '""' ) AS input,
       IFNULL( data_has_din.din, data_has_npn.npn ) AS `din/npn`,
       IFNULL( MIN( dp_product.brand_name ), MIN( nhp_product.product_name ) ) AS `match`,
       IF( data_has_din.din IS NOT NULL, "drug", IF( data_has_npn.npn IS NOT NULL, "natural", NULL ) ) AS `database`,
       IFNULL( data_has_din.type, data_has_npn.type ) AS type,
       IFNULL( data_has_din.source, data_has_npn.source ) AS source,
       GROUP_CONCAT( DISTINCT anumber ORDER BY anumber SEPARATOR "|" ) AS anumber,
       GROUP_CONCAT( DISTINCT atc ORDER BY atc SEPARATOR "|" ) AS atc,
       GROUP_CONCAT( DISTINCT ahfs_number ORDER BY ahfs_number SEPARATOR "|" ) AS ahfs_number,
       GROUP_CONCAT( DISTINCT ahfs ORDER BY ahfs SEPARATOR "|" ) AS ahfs,
       GROUP_CONCAT(
         DISTINCT REPLACE( IFNULL( ingredient, proper_name ), '"', '""' )
         ORDER BY ingredient SEPARATOR "|"
       ) AS ingredients
FROM data
LEFT JOIN data_has_din USING( identifier )
LEFT JOIN dp_product USING( din )
LEFT JOIN data_has_npn USING( identifier )
LEFT JOIN nhp_product USING ( npn )
LEFT JOIN dp_therapeutic_class ON dp_product.id = dp_therapeutic_class.dp_id
LEFT JOIN dp_active_ingredient ON dp_product.id = dp_active_ingredient.dp_id
LEFT JOIN nhp_medicinal_ingredient ON nhp_product.id = nhp_medicinal_ingredient.nhp_id
GROUP BY identifier
ORDER BY data.identifier;
