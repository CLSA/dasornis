SELECT
  data.identifier,
  REPLACE( data.input, '"', '""' ) AS input,
  IFNULL( data_has_din.din, data_has_npn.npn ) AS `din/npn`,
  IFNULL( MIN( dp_product.brand_name ), MIN( lnhpd_product.product_name ) ) AS `match`,
  IF(
    data_has_din.din IS NOT NULL,
    "drug",
    IF( data_has_npn.npn IS NOT NULL, "natural", NULL )
  ) AS `database`,
  IFNULL( data_has_din.type, data_has_npn.type ) AS type,
  IFNULL( data_has_din.source, data_has_npn.source ) AS source,
  GROUP_CONCAT(
    DISTINCT dp_therapeutic_class.anumber
    ORDER BY dp_therapeutic_class.anumber
    SEPARATOR "|"
  ) AS anumber,
  GROUP_CONCAT(
    DISTINCT dp_therapeutic_class.atc
    ORDER BY dp_therapeutic_class.atc
    SEPARATOR "|"
  ) AS atc,
  GROUP_CONCAT(
    DISTINCT REPLACE( IFNULL( dp_active_ingredient.ingredient, lnhpd_ingredient.name ), '"', '""' )
    ORDER BY REPLACE( IFNULL( dp_active_ingredient.ingredient, lnhpd_ingredient.name ), '"', '""' ) SEPARATOR "|"
  ) AS ingredients
FROM data
LEFT JOIN data_has_din USING( identifier )
LEFT JOIN dp_product USING( din )
LEFT JOIN data_has_npn USING( identifier )
LEFT JOIN lnhpd_product USING ( npn )
LEFT JOIN dp_therapeutic_class ON dp_product.id = dp_therapeutic_class.dp_id
LEFT JOIN dp_active_ingredient ON dp_product.id = dp_active_ingredient.dp_id
LEFT JOIN lnhpd_ingredient USING ( lnhpd_id )
GROUP BY data.identifier
ORDER BY data.identifier;
