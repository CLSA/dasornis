SELECT data.id_name_sp AS input,
       IFNULL( dp_product.brand_name, nhp_product.product_name ) AS `match`,
       IFNULL( dp_product.din, nhp_product.npn ) AS `din/npn`,
       IF(
         dp_id IS NOT NULL,
         IFNULL( GROUP_CONCAT( DISTINCT anumber ORDER BY anumber SEPARATOR " " ), "" ),
         ""
       ) AS `dtc`,
       IF(
         dp_id IS NOT NULL,
         IFNULL( GROUP_CONCAT( DISTINCT ahfs_number ORDER BY ahfs_number SEPARATOR " " ), "" ),
         ""
       ) AS `ahfs`,
       IF( dp_id IS NOT NULL, "drug", "natural" ) AS `database`,
       IFNULL( data_has_dp_product.type, data_has_nhp_product.type ) AS type,
       COUNT(*) AS matches,
       IF( also_natural_name IS NOT NULL, IF( also_natural_name, "yes", "no" ), "" ) AS `both`
FROM data
LEFT JOIN data_has_dp_product USING( uid )
LEFT JOIN dp_product ON data_has_dp_product.dp_id = dp_product.id
LEFT JOIN drug_name USING( dp_id )
LEFT JOIN dp_therapeutic_class USING( dp_id )
LEFT JOIN data_has_nhp_product USING( uid )
LEFT JOIN nhp_product ON data_has_nhp_product.nhp_id = nhp_product.id
WHERE id_din_sp IS NULL
  AND id_name_sp IS NOT NULL
  AND ( dp_id IS NOT NULL OR nhp_id IS NOT NULL )
GROUP BY uid
ORDER BY IF( dp_id IS NOT NULL, "drug", "natural" ),
         IFNULL( data_has_dp_product.type, data_has_nhp_product.type ),
         COUNT(*) DESC,
         id_name_sp;
