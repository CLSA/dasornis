SELECT "Creating packaging table" AS "";

CREATE TABLE dp_packaging (
  dp_id INT NOT NULL,
  upc VARCHAR(12),
  package_size_unit VARCHAR(40),
  package_type VARCHAR(40),
  package_size VARCHAR(5),
  product_information VARCHAR(80),
  KEY fk_dp_id (dp_id),
  KEY dk_upc ( upc ),
  KEY dk_package_size_unit ( package_size_unit ),
  KEY dk_package_type ( package_type ),
  KEY dk_package_size ( package_size ),
  CONSTRAINT fk_dp_packaging_dp_id FOREIGN KEY (dp_id)
  REFERENCES dp_product(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB CHARSET=utf8;

LOAD DATA LOCAL INFILE "enc_package.txt"
INTO TABLE dp_packaging CHARACTER SET UTF8
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\n"
( @col_0, @col_1, @col_2, @col_3, @col_4, @col_5 )
SET dp_id = @col_0,
    upc = NULLIF( @col_1, "" ),
    package_size_unit = NULLIF( @col_2, "" ),
    package_type = NULLIF( @col_3, "" ),
    package_size = NULLIF( @col_4, "" ),
    product_information = NULLIF( @col_5, "" );

LOAD DATA LOCAL INFILE "enc_package_ap.txt"
INTO TABLE dp_packaging CHARACTER SET UTF8
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\n"
( @col_0, @col_1, @col_2, @col_3, @col_4, @col_5 )
SET dp_id = @col_0,
    upc = NULLIF( @col_1, "" ),
    package_size_unit = NULLIF( @col_2, "" ),
    package_type = NULLIF( @col_3, "" ),
    package_size = NULLIF( @col_4, "" ),
    product_information = NULLIF( @col_5, "" );

LOAD DATA LOCAL INFILE "enc_package_ia.txt"
INTO TABLE dp_packaging CHARACTER SET UTF8
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\n"
( @col_0, @col_1, @col_2, @col_3, @col_4, @col_5 )
SET dp_id = @col_0,
    upc = NULLIF( @col_1, "" ),
    package_size_unit = NULLIF( @col_2, "" ),
    package_type = NULLIF( @col_3, "" ),
    package_size = NULLIF( @col_4, "" ),
    product_information = NULLIF( @col_5, "" );

LOAD DATA LOCAL INFILE "enc_package_dr.txt"
INTO TABLE dp_packaging CHARACTER SET UTF8
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\n"
( @col_0, @col_1, @col_2, @col_3, @col_4, @col_5 )
SET dp_id = @col_0,
    upc = NULLIF( @col_1, "" ),
    package_size_unit = NULLIF( @col_2, "" ),
    package_type = NULLIF( @col_3, "" ),
    package_size = NULLIF( @col_4, "" ),
    product_information = NULLIF( @col_5, "" );
