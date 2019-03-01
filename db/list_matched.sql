SELECT data.uid,
       data.id_name_sp AS input,
       IFNULL( data_has_din.din, data_has_npn.npn ) AS `din/npn`,
       IFNULL( MIN( dp_product.brand_name ), MIN( nhp_product.product_name ) ) AS `match`,
       IF( data_has_din.din IS NOT NULL, "drug", "natural" ) AS `database`,
       IFNULL( data_has_din.type, data_has_npn.type ) AS type,
       IFNULL( data_has_din.source, data_has_npn.source ) AS source
FROM data
LEFT JOIN data_has_din USING( uid )
LEFT JOIN dp_product USING( din )
LEFT JOIN data_has_npn USING( uid )
LEFT JOIN nhp_product USING ( npn )
WHERE data.match_found = 1
GROUP BY uid, IFNULL( din, npn )
ORDER BY data.uid;
