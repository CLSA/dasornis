SELECT "Creating pharmaceutical_std table" AS "";

DROP TABLE IF EXISTS pharmaceutical_std;
CREATE TABLE pharmaceutical_std (
  drug_code INT NOT NULL,
  pharmaceutical_std VARCHAR(40),
  KEY fk_drug_code (drug_code),
  KEY dk_pharmaceutical_std ( pharmaceutical_std ),
  CONSTRAINT fk_parmaceutical_std_drug_code FOREIGN KEY (drug_code)
  REFERENCES drug_product(drug_code) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB CHARSET=utf8;

LOAD DATA LOCAL INFILE "pharm.txt"
INTO TABLE pharmaceutical_std
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
( @col_0, @col_1 )
SET drug_code = @col_0,
    pharmaceutical_std = NULLIF( @col_1, "" );

LOAD DATA LOCAL INFILE "pharm_ap.txt"
INTO TABLE pharmaceutical_std
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
( @col_0, @col_1 )
SET drug_code = @col_0,
    pharmaceutical_std = NULLIF( @col_1, "" );

LOAD DATA LOCAL INFILE "pharm_ia.txt"
INTO TABLE pharmaceutical_std
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
( @col_0, @col_1 )
SET drug_code = @col_0,
    pharmaceutical_std = NULLIF( @col_1, "" );
