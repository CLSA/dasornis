SELECT "Creating medicinal_ingredient table" AS "";

DROP TABLE IF EXISTS nhp_medicinal_ingredient;
CREATE TABLE nhp_medicinal_ingredient (
  nhp_id INT(11),
  proper_name VARCHAR(200),
  proper_name_french VARCHAR(200),
  common_name VARCHAR(200),
  common_name_french VARCHAR(200),
  potency_amount INT(11),
  potency_unit_of_measure VARCHAR(120),
  potency_unit_of_measure_french VARCHAR(120),
  potency_constituent VARCHAR(120),
  quantity INT(11),
  quantity_minimum INT(11),
  quantity_maximum INT(11),
  quantity_unit_of_measure VARCHAR(120),
  quantity_unit_of_measure_french VARCHAR(120),
  ratio_numerator VARCHAR(10),
  ratio_denominator VARCHAR(10),
  dried_herb_equivalent VARCHAR(10),
  dhe_unit_of_measure VARCHAR(120),
  dhe_unit_of_measure_french VARCHAR(120),
  extract_type_desc VARCHAR(120),
  extract_type_desc_french VARCHAR(120),
  source_material VARCHAR(120),
  source_material_french VARCHAR(120),
  KEY fk_nhp_id (nhp_id),
  CONSTRAINT fk_nhp_medicinal_ingredient_nhp_id FOREIGN KEY (nhp_id)
  REFERENCES nhp_product(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB CHARSET=utf8;

LOAD DATA LOCAL INFILE "enc_NHP_MEDICINAL_INGREDIENTS.txt"
INTO TABLE nhp_medicinal_ingredient CHARACTER SET UTF8
FIELDS TERMINATED BY "|"
LINES TERMINATED BY "\r\n"
( @col_0, @col_1, @col_2, @col_3, @col_4, @col_5, @col_6, @col_7, @col_8, @col_9,
  @col_a, @col_b, @col_c, @col_d, @col_e, @col_f, @col_g, @col_h, @col_i, @col_j,
  @col_k, @col_l, @col_m )
SET nhp_id = @col_0,
    proper_name = NULLIF( @col_1, "" ),
    proper_name_french = NULLIF( @col_2, "" ),
    common_name = NULLIF( @col_3, "" ),
    common_name_french = NULLIF( @col_4, "" ),
    potency_amount = NULLIF( @col_5, "" ),
    potency_unit_of_measure = NULLIF( @col_6, "" ),
    potency_unit_of_measure_french = NULLIF( @col_7, "" ),
    potency_constituent = NULLIF( @col_8, "" ),
    quantity = NULLIF( @col_9, "" ),
    quantity_minimum = NULLIF( @col_a, "" ),
    quantity_maximum = NULLIF( @col_b, "" ),
    quantity_unit_of_measure = NULLIF( @col_c, "" ),
    quantity_unit_of_measure_french = NULLIF( @col_d, "" ),
    ratio_numerator = NULLIF( @col_e, "" ),
    ratio_denominator = NULLIF( @col_f, "" ),
    dried_herb_equivalent = NULLIF( @col_g, "" ),
    dhe_unit_of_measure = NULLIF( @col_h, "" ),
    dhe_unit_of_measure_french = NULLIF( @col_i, "" ),
    extract_type_desc = NULLIF( @col_j, "" ),
    extract_type_desc_french = NULLIF( @col_k, "" ),
    source_material = NULLIF( @col_l, "" ),
    source_material_french = NULLIF( @col_m, "" );
