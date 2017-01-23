SELECT "Creating product table" AS "";

DROP TABLE IF EXISTS nhp_product;
CREATE TABLE nhp_product (
  id INT(11),
  npn CHAR(8),
  product_name VARCHAR(200),
  dosage_form VARCHAR(120),
  dosage_form_french VARCHAR(120),
  licence_date DATE,
  status VARCHAR(20),
  status_french VARCHAR(20),
  PRIMARY KEY (id),
  INDEX dk_npn (npn)
) ENGINE=InnoDB CHARSET=utf8;

LOAD DATA LOCAL INFILE "enc_NHP_PRODUCTS.txt"
INTO TABLE nhp_product CHARACTER SET UTF8
FIELDS TERMINATED BY '|' ENCLOSED BY '' ESCAPED BY ''
LINES TERMINATED BY "\r\n"
( @col_0, @col_1, @col_2, @col_3, @col_4, @col_5, @col_6, @col_7 )
SET id = @col_0,
    npn = NULLIF( @col_1, "" ),
    product_name = NULLIF( @col_2, "" ),
    dosage_form = NULLIF( @col_3, "" ),
    dosage_form_french = NULLIF( @col_4, "" ),
    licence_date = STR_TO_DATE( @col_5, "%d-%b-%Y" ),
    status = NULLIF( @col_6, "" ),
    status_french = NULLIF( @col_7, "" );
