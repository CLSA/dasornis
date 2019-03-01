SELECT data.uid,
       data.id_name_sp AS input,
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
WHERE data.id_name_sp IS NOT NULL
  AND din IS NULL
  AND npn IS NULL
ORDER BY id_name_sp;
