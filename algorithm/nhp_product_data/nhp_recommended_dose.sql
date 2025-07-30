SELECT "Creating recommended_dose table" AS "";

DROP TABLE IF EXISTS nhp_recommended_dose;
CREATE TABLE nhp_recommended_dose (
  nhp_id INT(11),
  population_type_desc VARCHAR(120),
  population_type_desc_french VARCHAR(120),
  age INT(11),
  age_minimum INT(11),
  age_maximum INT(11),
  uom_type_desc_age VARCHAR(120),
  uom_type_desc_age_french VARCHAR(120),
  quantity_dose INT(11),
  quantity_minimum_dose INT(11),
  quantity_maximum_dose INT(11),
  uom_type_desc_quantity_dose VARCHAR(120),
  uom_type_desc_quantity_dose_french VARCHAR(120),
  frequency INT(11),
  frequency_minimum INT(11),
  frequency_maximum INT(11),
  uom_type_desc_frequency VARCHAR(120),
  uom_type_desc_frequency_french VARCHAR(120),
  KEY fk_nhp_id (nhp_id),
  CONSTRAINT fk_nhp_recommended_dose_nhp_id FOREIGN KEY (nhp_id)
  REFERENCES nhp_product(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB CHARSET=utf8;

LOAD DATA LOCAL INFILE "enc_NHP_PROD_RECOMMENDED_DOSE.txt"
INTO TABLE nhp_recommended_dose CHARACTER SET UTF8
FIELDS TERMINATED BY "|"
LINES TERMINATED BY "\n"
( @col_0, @col_1, @col_2, @col_3, @col_4, @col_5, @col_6, @col_7, @col_8, @col_9,
  @col_a, @col_b, @col_c, @col_d, @col_e, @col_f, @col_g, @col_h )
SET nhp_id = @col_0,
    population_type_desc = NULLIF( @col_1, "" ),
    population_type_desc_french = NULLIF( @col_2, "" ),
    age = NULLIF( @col_3, "" ),
    age_minimum = NULLIF( @col_4, "" ),
    age_maximum = NULLIF( @col_5, "" ),
    uom_type_desc_age = NULLIF( @col_6, "" ),
    uom_type_desc_age_french = NULLIF( @col_7, "" ),
    quantity_dose = NULLIF( @col_8, "" ),
    quantity_minimum_dose = NULLIF( @col_9, "" ),
    quantity_maximum_dose = NULLIF( @col_a, "" ),
    uom_type_desc_quantity_dose = NULLIF( @col_b, "" ),
    uom_type_desc_quantity_dose_french = NULLIF( @col_c, "" ),
    frequency = NULLIF( @col_d, "" ),
    frequency_minimum = NULLIF( @col_e, "" ),
    frequency_maximum = NULLIF( @col_f, "" ),
    uom_type_desc_frequency = NULLIF( @col_g, "" ),
    uom_type_desc_frequency_french = NULLIF( @col_h, "" );
