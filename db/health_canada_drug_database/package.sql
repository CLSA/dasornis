SELECT "Creating packaging table" AS "";

DROP TABLE IF EXISTS packaging;
CREATE TABLE packaging (
  drug_code INT NOT NULL,
  upc VARCHAR(12),
  package_size_unit VARCHAR(40),
  package_type VARCHAR(40),
  package_size VARCHAR(5),
  product_information VARCHAR(80),
  KEY fk_drug_code (drug_code),
  KEY dk_upc ( upc ),
  KEY dk_package_size_unit ( package_size_unit ),
  KEY dk_package_type ( package_type ),
  KEY dk_package_size ( package_size ),
  CONSTRAINT fk_packaging_drug_code FOREIGN KEY (drug_code)
  REFERENCES drug_product(drug_code) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB CHARSET=utf8;

LOAD DATA LOCAL INFILE "package.txt"
INTO TABLE packaging
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
( @col_0, @col_1, @col_2, @col_3, @col_4, @col_5 )
SET drug_code = @col_0,
    upc = NULLIF( @col_1, "" ),
    package_size_unit = NULLIF( @col_2, "" ),
    package_type = NULLIF( @col_3, "" ),
    package_size = NULLIF( @col_4, "" ),
    product_information = NULLIF( @col_5, "" );

LOAD DATA LOCAL INFILE "package_ap.txt"
INTO TABLE packaging
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
( @col_0, @col_1, @col_2, @col_3, @col_4, @col_5 )
SET drug_code = @col_0,
    upc = NULLIF( @col_1, "" ),
    package_size_unit = NULLIF( @col_2, "" ),
    package_type = NULLIF( @col_3, "" ),
    package_size = NULLIF( @col_4, "" ),
    product_information = NULLIF( @col_5, "" );

LOAD DATA LOCAL INFILE "package_ia.txt"
INTO TABLE packaging
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
( @col_0, @col_1, @col_2, @col_3, @col_4, @col_5 )
SET drug_code = @col_0,
    upc = NULLIF( @col_1, "" ),
    package_size_unit = NULLIF( @col_2, "" ),
    package_type = NULLIF( @col_3, "" ),
    package_size = NULLIF( @col_4, "" ),
    product_information = NULLIF( @col_5, "" );
