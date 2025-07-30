SELECT "Creating active_ingredient table" AS "";

CREATE TABLE dp_active_ingredient (
  dp_id INT NOT NULL,
  code INT,
  ingredient VARCHAR(240),
  strength VARCHAR(20),
  strength_unit VARCHAR(40),
  strength_type VARCHAR(40),
  dosage_value VARCHAR(20),
  base TINYINT(1),
  dosage_unit VARCHAR(40),
  notes VARCHAR(2000),
  KEY fk_dp_id (dp_id),
  KEY dk_ingredient ( ingredient ),
  KEY dk_strength ( strength ),
  KEY dk_strength_unit ( strength_unit ),
  CONSTRAINT fk_dp_active_ingredient_dp_id FOREIGN KEY (dp_id)
  REFERENCES dp_product(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB CHARSET=utf8;

LOAD DATA LOCAL INFILE "enc_ingred.txt"
INTO TABLE dp_active_ingredient CHARACTER SET UTF8
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\n"
( @col_0, @col_1, @col_2, @col_3, @col_4, @col_5, @col_6, @col_7, @col_8, @col_9, @col_a )
SET dp_id = @col_0,
    code = NULLIF( @col_1, "" ),
    ingredient = NULLIF( @col_2, "" ),
    strength = NULLIF( @col_4, "" ),
    strength_unit = NULLIF( @col_5, "" ),
    strength_type = NULLIF( @col_6, "" ),
    dosage_value = NULLIF( @col_7, "" ),
    base = IF( ""=@col_8, NULL, IF( "Y"=@col_8, 1, 0 ) ),
    dosage_unit = NULLIF( @col_9, "" ),
    notes = NULLIF( @col_a, "" );

LOAD DATA LOCAL INFILE "enc_ingred_ap.txt"
INTO TABLE dp_active_ingredient CHARACTER SET UTF8
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\n"
( @col_0, @col_1, @col_2, @col_3, @col_4, @col_5, @col_6, @col_7, @col_8, @col_9, @col_a )
SET dp_id = @col_0,
    code = NULLIF( @col_1, "" ),
    ingredient = NULLIF( @col_2, "" ),
    strength = NULLIF( @col_4, "" ),
    strength_unit = NULLIF( @col_5, "" ),
    strength_type = NULLIF( @col_6, "" ),
    dosage_value = NULLIF( @col_7, "" ),
    base = IF( ""=@col_8, NULL, IF( "Y"=@col_8, 1, 0 ) ),
    dosage_unit = NULLIF( @col_9, "" ),
    notes = NULLIF( @col_a, "" );

LOAD DATA LOCAL INFILE "enc_ingred_ia.txt"
INTO TABLE dp_active_ingredient CHARACTER SET UTF8
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\n"
( @col_0, @col_1, @col_2, @col_3, @col_4, @col_5, @col_6, @col_7, @col_8, @col_9, @col_a )
SET dp_id = @col_0,
    code = NULLIF( @col_1, "" ),
    ingredient = NULLIF( @col_2, "" ),
    strength = NULLIF( @col_4, "" ),
    strength_unit = NULLIF( @col_5, "" ),
    strength_type = NULLIF( @col_6, "" ),
    dosage_value = NULLIF( @col_7, "" ),
    base = IF( ""=@col_8, NULL, IF( "Y"=@col_8, 1, 0 ) ),
    dosage_unit = NULLIF( @col_9, "" ),
    notes = NULLIF( @col_a, "" );

LOAD DATA LOCAL INFILE "enc_ingred_dr.txt"
INTO TABLE dp_active_ingredient CHARACTER SET UTF8
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\n"
( @col_0, @col_1, @col_2, @col_3, @col_4, @col_5, @col_6, @col_7, @col_8, @col_9, @col_a )
SET dp_id = @col_0,
    code = NULLIF( @col_1, "" ),
    ingredient = NULLIF( @col_2, "" ),
    strength = NULLIF( @col_4, "" ),
    strength_unit = NULLIF( @col_5, "" ),
    strength_type = NULLIF( @col_6, "" ),
    dosage_value = NULLIF( @col_7, "" ),
    base = IF( ""=@col_8, NULL, IF( "Y"=@col_8, 1, 0 ) ),
    dosage_unit = NULLIF( @col_9, "" ),
    notes = NULLIF( @col_a, "" );
