SELECT "Creating therapeutic_class table" AS "";

CREATE TABLE dp_therapeutic_class (
  dp_id INT NOT NULL,
  atc_number VARCHAR(20),
  atc VARCHAR(120),
  KEY fk_dp_id (dp_id),
  KEY dk_atc_number ( atc_number ),
  KEY dk_atc ( atc ),
  CONSTRAINT fk_dp_therapeutic_class_dp_id FOREIGN KEY (dp_id)
  REFERENCES dp_product(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB CHARSET=utf8;

LOAD DATA LOCAL INFILE "enc_ther.txt"
INTO TABLE dp_therapeutic_class CHARACTER SET UTF8
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\n"
( @col_0, @col_1, @col_2, @col_3 )
SET dp_id = @col_0,
    atc_number = NULLIF( @col_1, "" ),
    atc = NULLIF( @col_2, "" );

LOAD DATA LOCAL INFILE "enc_ther_ap.txt"
INTO TABLE dp_therapeutic_class CHARACTER SET UTF8
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\n"
( @col_0, @col_1, @col_2, @col_3 )
SET dp_id = @col_0,
    atc_number = NULLIF( @col_1, "" ),
    atc = NULLIF( @col_2, "" );

LOAD DATA LOCAL INFILE "enc_ther_ia.txt"
INTO TABLE dp_therapeutic_class CHARACTER SET UTF8
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\n"
( @col_0, @col_1, @col_2, @col_3 )
SET dp_id = @col_0,
    atc_number = NULLIF( @col_1, "" ),
    atc = NULLIF( @col_2, "" );

LOAD DATA LOCAL INFILE "enc_ther_dr.txt"
INTO TABLE dp_therapeutic_class CHARACTER SET UTF8
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\n"
( @col_0, @col_1, @col_2, @col_3 )
SET dp_id = @col_0,
    atc_number = NULLIF( @col_1, "" ),
    atc = NULLIF( @col_2, "" );
