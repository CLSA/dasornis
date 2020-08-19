SELECT data.uid,
       REPLACE( IFNULL( data.id_name_sp, data.id_din_sp ), '"', '""' ) AS input,
       data.pres,
       data.dose_nb,
       data.dose_unit,
       data.dose_frq,
       data.dose_frq_otsp,
       data.dose_cmt,
       data.use2,
       data.reason_sp
FROM data
LEFT JOIN data_has_din USING( uid )
LEFT JOIN data_has_npn USING( uid )
WHERE din IS NULL
  AND npn IS NULL
ORDER BY uid;
