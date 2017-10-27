DROP TABLE IF EXISTS uid_matches;
CREATE TEMPORARY TABLE uid_matches
SELECT uid, COUNT(*) AS matches
FROM data
LEFT JOIN data_has_dp_product USING( uid )
LEFT JOIN dp_product ON data_has_dp_product.dp_id = dp_product.id
LEFT JOIN drug_name USING( dp_id )
LEFT JOIN data_has_nhp_product USING( uid )
LEFT JOIN nhp_product ON data_has_nhp_product.nhp_id = nhp_product.id
WHERE id_din_sp IS NULL
  AND id_name_sp IS NOT NULL
  AND ( dp_id IS NOT NULL OR nhp_id IS NOT NULL )
GROUP BY uid 
ORDER BY data.id_name_sp, IFNULL( dp_product.brand_name, nhp_product.product_name );


DROP TABLE IF EXISTS multiple_uids;
CREATE TEMPORARY TABLE multiple_uids
SELECT DISTINCT uid FROM uid_matches WHERE matches > 1;
ALTER TABLE multiple_uids ADD INDEX dk_uid (uid);


DROP TABLE IF EXISTS multiple_matches;
CREATE TEMPORARY TABLE multiple_matches
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
       IFNULL( pres, "" ) pres,
       IFNULL( data_has_dp_product.type, data_has_nhp_product.type ) AS type,
       IF( also_natural_name IS NOT NULL, IF( also_natural_name, "yes", "no" ), "" ) AS `both`
FROM data
JOIN multiple_uids USING( uid )
LEFT JOIN data_has_dp_product USING( uid )
LEFT JOIN dp_product ON data_has_dp_product.dp_id = dp_product.id
LEFT JOIN drug_name USING( dp_id )
LEFT JOIN dp_therapeutic_class USING( dp_id )
LEFT JOIN data_has_nhp_product USING( uid )
LEFT JOIN nhp_product ON data_has_nhp_product.nhp_id = nhp_product.id
WHERE id_din_sp IS NULL
  AND id_name_sp IS NOT NULL
  AND ( dp_id IS NOT NULL OR nhp_id IS NOT NULL )
GROUP BY uid, IFNULL( dp_id, nhp_id )
ORDER BY data.id_name_sp, IFNULL( dp_product.brand_name, nhp_product.product_name );


-- now get the list made above without repeating any rows
SELECT DISTINCT `input`,`match`,`din/npn`,`dtc`,`ahfs`,`database`,`pres`,`type`,`both`
FROM multiple_matches;
