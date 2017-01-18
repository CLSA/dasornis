SELECT "Creating therapeutic_class table" AS "";

DROP TABLE IF EXISTS therapeutic_class;
CREATE TABLE therapeutic_class (
  drug_code INT NOT NULL,
  tc_atc_number VARCHAR(8),
  tc_atc VARCHAR(120),
  tc_ahfs_number VARCHAR(20),
  tc_ahfs VARCHAR(80),
  KEY fk_drug_code (drug_code),
  KEY dk_tc_atc ( tc_atc ),
  KEY dk_tc_ahfs ( tc_ahfs ),
  CONSTRAINT fk_ther_drug_code FOREIGN KEY (drug_code)
  REFERENCES drug_product(drug_code) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB CHARSET=utf8;

LOAD DATA LOCAL INFILE "ther.txt"
INTO TABLE therapeutic_class
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
( @col_0, @col_1, @col_2, @col_3, @col_4 )
SET drug_code = @col_0,
    tc_atc_number = NULLIF( @col_1, "" ),
    tc_atc = NULLIF( @col_2, "" ),
    tc_ahfs_number = NULLIF( @col_3, "" ),
    tc_ahfs = NULLIF( @col_4, "" );

LOAD DATA LOCAL INFILE "ther_ap.txt"
INTO TABLE therapeutic_class
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
( @col_0, @col_1, @col_2, @col_3, @col_4 )
SET drug_code = @col_0,
    tc_atc_number = NULLIF( @col_1, "" ),
    tc_atc = NULLIF( @col_2, "" ),
    tc_ahfs_number = NULLIF( @col_3, "" ),
    tc_ahfs = NULLIF( @col_4, "" );

LOAD DATA LOCAL INFILE "ther_ia.txt"
INTO TABLE therapeutic_class
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
( @col_0, @col_1, @col_2, @col_3, @col_4 )
SET drug_code = @col_0,
    tc_atc_number = NULLIF( @col_1, "" ),
    tc_atc = NULLIF( @col_2, "" ),
    tc_ahfs_number = NULLIF( @col_3, "" ),
    tc_ahfs = NULLIF( @col_4, "" );
