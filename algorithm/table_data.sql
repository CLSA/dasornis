-- Dumps all relevant data used by coders for manual coding

SELECT
  din,
  brand_name,
  class,
  categorization,
  descriptor,
  pediatric_flag,
  accession_number,
  number_of_ais,
  last_update_date,
  ai_group_no,
  company_name,
  GROUP_CONCAT( distinct pharmaceutical_form ORDER BY pharmaceutical_form ) AS forms,
  GROUP_CONCAT( distinct standard ORDER BY standard ) AS standards,
  GROUP_CONCAT( distinct route ORDER BY route ) AS routes,
  GROUP_CONCAT( distinct schedule ORDER BY schedule ) AS schedules,
  GROUP_CONCAT( distinct status ORDER BY status ) AS statuses,
  GROUP_CONCAT( distinct ahfs_number ORDER BY ahfs_number ) AS ahfs_numbers
FROM dp_product
LEFT JOIN dp_company ON dp_product.id = dp_company.dp_id
LEFT JOIN dp_form ON dp_product.id = dp_form.dp_id
LEFT JOIN dp_pharmaceutical_standard ON dp_product.id = dp_pharmaceutical_standard.dp_id
LEFT JOIN dp_route ON dp_product.id = dp_route.dp_id
LEFT JOIN dp_schedule ON dp_product.id = dp_schedule.dp_id
LEFT JOIN dp_status ON dp_product.id = dp_status.dp_id
LEFT JOIN dp_therapeutic_class ON dp_product.id = dp_therapeutic_class.dp_id
WHERE din IS NOT NULL and brand_name IS NOT NULL
GROUP BY dp_product.id
ORDER BY din, brand_name;

SELECT
  din,
  ingredient,
  code,
  strength,
  strength_unit,
  dosage_value,
  base,
  dosage_unit
FROM dp_active_ingredient
JOIN dp_product ON dp_active_ingredient.dp_id = dp_product.id
WHERE din IS NOT NULL and brand_name IS NOT NULL
ORDER BY din, ingredient;

SELECT
  npn,
  product_name,
  company_name
FROM lnhpd_product
GROUP BY lnhpd_product.lnhpd_id
ORDER BY npn, product_name;

SELECT
  npn,
  name,
  potency_amount,
  potency_unit_of_measure,
  potency_constituent,
  quantity,
  quantity_minimum,
  quantity_maximum,
  quantity_unit_of_measure,
  ratio_numerator,
  ratio_denominator,
  dried_herb_equivalent,
  dhe_unit_of_measure
FROM lnhpd_ingredient
JOIN lnhpd_product USING ( lnhpd_id )
ORDER BY npn, name;
