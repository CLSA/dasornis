-- Dumps all relevant data used by coders for manual coding

select
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
  group_concat( distinct pharmaceutical_form order by pharmaceutical_form ) AS forms,
  group_concat( distinct standard order by standard ) AS standards,
  group_concat( distinct route order by route ) AS routes,
  group_concat( distinct schedule order by schedule ) AS schedules,
  group_concat( distinct status order by status ) AS statuses,
  group_concat( distinct ahfs_number order by ahfs_number ) AS ahfs_numbers
from dp_product
left join dp_company on dp_product.id = dp_company.dp_id
left join dp_form on dp_product.id = dp_form.dp_id
left join dp_pharmaceutical_standard on dp_product.id = dp_pharmaceutical_standard.dp_id
left join dp_route on dp_product.id = dp_route.dp_id
left join dp_schedule on dp_product.id = dp_schedule.dp_id
left join dp_status on dp_product.id = dp_status.dp_id
left join dp_therapeutic_class on dp_product.id = dp_therapeutic_class.dp_id
where din is not null and brand_name is not null
group by dp_product.id
order by din, brand_name;

select
  din,
  ingredient,
  code,
  strength,
  strength_unit,
  dosage_value,
  base,
  dosage_unit
from dp_active_ingredient
join dp_product on dp_active_ingredient.dp_id = dp_product.id
where din is not null and brand_name is not null
order by din, ingredient;

select
  npn,
  product_name,
  dosage_form,
  licence_date,
  status,
  company_name,
  group_concat( distinct route_type_desc order by route_type_desc ) AS routes
from nhp_product
left join nhp_company on nhp_product.id = nhp_company.nhp_id
left join nhp_route on nhp_product.id = nhp_route.nhp_id
where npn is not null and product_name is not null
group by nhp_product.id
order by npn, product_name;

select
  npn,
  proper_name,
  common_name,
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
from nhp_medicinal_ingredient
join nhp_product on nhp_medicinal_ingredient.nhp_id = nhp_product.id
where npn is not null and product_name is not null
order by npn, proper_name;

