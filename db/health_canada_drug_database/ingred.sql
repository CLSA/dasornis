SELECT "Creating active_ingredients table" AS "";

DROP TABLE IF EXISTS active_ingredients;
CREATE TABLE active_ingredients (
  drug_code INT NOT NULL,
  active_ingredient_code INT,
  ingredient VARCHAR(240),
  ingredient_supplied_ind VARCHAR(1),
  strength VARCHAR(20),
  strength_unit VARCHAR(40),
  strength_type VARCHAR(40),
  dosage_value VARCHAR(20),
  base VARCHAR(1),
  dosage_unit VARCHAR(40),
  notes VARCHAR(2000),
  KEY fk_drug_code (drug_code),
  KEY dk_ingredient ( ingredient ),
  KEY dk_strength ( strength ),
  KEY dk_strength_unit ( strength_unit ),
  CONSTRAINT fk_active_ingredients_drug_code FOREIGN KEY (drug_code)
  REFERENCES drug_product(drug_code) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB CHARSET=utf8;

LOAD DATA LOCAL INFILE "ingred.txt"
INTO TABLE active_ingredients
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
( @col_0, @col_1, @col_2, @col_3, @col_4, @col_5, @col_6, @col_7, @col_8, @col_9, @col_a )
SET drug_code = @col_0,
    active_ingredient_code = NULLIF( @col_1, "" ),
    ingredient = NULLIF( @col_2, "" ),
    ingredient_supplied_ind = NULLIF( @col_3, "" ),
    strength = NULLIF( @col_4, "" ),
    strength_unit = NULLIF( @col_5, "" ),
    strength_type = NULLIF( @col_6, "" ),
    dosage_value = NULLIF( @col_7, "" ),
    base = NULLIF( @col_8, "" ),
    dosage_unit = NULLIF( @col_9, "" ),
    notes = NULLIF( @col_a, "" );

LOAD DATA LOCAL INFILE "ingred_ap.txt"
INTO TABLE active_ingredients
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
( @col_0, @col_1, @col_2, @col_3, @col_4, @col_5, @col_6, @col_7, @col_8, @col_9, @col_a )
SET drug_code = @col_0,
    active_ingredient_code = NULLIF( @col_1, "" ),
    ingredient = NULLIF( @col_2, "" ),
    ingredient_supplied_ind = NULLIF( @col_3, "" ),
    strength = NULLIF( @col_4, "" ),
    strength_unit = NULLIF( @col_5, "" ),
    strength_type = NULLIF( @col_6, "" ),
    dosage_value = NULLIF( @col_7, "" ),
    base = NULLIF( @col_8, "" ),
    dosage_unit = NULLIF( @col_9, "" ),
    notes = NULLIF( @col_a, "" );

LOAD DATA LOCAL INFILE "ingred_ia.txt"
INTO TABLE active_ingredients
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
( @col_0, @col_1, @col_2, @col_3, @col_4, @col_5, @col_6, @col_7, @col_8, @col_9, @col_a )
SET drug_code = @col_0,
    active_ingredient_code = NULLIF( @col_1, "" ),
    ingredient = NULLIF( @col_2, "" ),
    ingredient_supplied_ind = NULLIF( @col_3, "" ),
    strength = NULLIF( @col_4, "" ),
    strength_unit = NULLIF( @col_5, "" ),
    strength_type = NULLIF( @col_6, "" ),
    dosage_value = NULLIF( @col_7, "" ),
    base = NULLIF( @col_8, "" ),
    dosage_unit = NULLIF( @col_9, "" ),
    notes = NULLIF( @col_a, "" );
