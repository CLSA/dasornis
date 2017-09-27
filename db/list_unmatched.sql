SELECT data.id_name_sp AS input,
       data.pres,
       data.dose_nb,
       data.dose_unit,
       data.dose_frq,
       data.dose_frq_otsp,
       data.dose_cmt,
       data.use2,
       data.reason_sp
FROM data
LEFT JOIN data_has_dp_product USING( uid )
LEFT JOIN dp_product ON data_has_dp_product.dp_id = dp_product.id
LEFT JOIN data_has_nhp_product USING( uid )
LEFT JOIN nhp_product ON data_has_nhp_product.nhp_id = nhp_product.id
WHERE id_din_sp IS NULL
  AND id_name_sp IS NOT NULL
  AND ( dp_id IS NULL AND nhp_id IS NULL )
GROUP BY uid
ORDER BY id_name_sp;
