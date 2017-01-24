-- ------------------------------------------------------------------------------------------------
SELECT data.id_name_sp AS input,
       IF( dp_id IS NOT NULL, dp_product.brand_name, IF( nhp_id IS NOT NULL, nhp_product.product_name, "" ) ) AS `match`,
       IF( dp_id IS NOT NULL, "drug", IF( nhp_id IS NOT NULL, "natural", "" ) ) AS `database`,
       IF( dp_id IS NOT NULL, data_has_dp_product.type, IF( nhp_id IS NOT NULL, data_has_nhp_product.type, "" ) ) AS type,
       IF( dp_id IS NOT NULL, COUNT(*), IF( nhp_id IS NOT NULL, COUNT(*), "" ) ) AS matches
-- INTO OUTFILE "matches.csv"
FROM data
LEFT JOIN data_has_dp_product USING( uid )
LEFT JOIN dp_product ON data_has_dp_product.dp_id = dp_product.id
LEFT JOIN data_has_nhp_product USING( uid )
LEFT JOIN nhp_product ON data_has_nhp_product.nhp_id = nhp_product.id
WHERE id_din_sp IS NULL and id_name_sp IS NOT NULL
GROUP BY uid
ORDER BY IF( dp_id IS NOT NULL, "drug", IF( nhp_id IS NOT NULL, "natural", "" ) ),
         IF( dp_id IS NOT NULL, data_has_dp_product.type, IF( nhp_id IS NOT NULL, data_has_nhp_product.type, "" ) ),
         IF( dp_id IS NOT NULL, COUNT(*), IF( nhp_id IS NOT NULL, COUNT(*), "" ) ) DESC,
         id_name_sp;

