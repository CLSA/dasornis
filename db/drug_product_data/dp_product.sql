SELECT "Creating product table" AS "";

CREATE TABLE dp_product (
  id INT NOT NULL,
  categorization VARCHAR(80),
  class VARCHAR(40),
  din VARCHAR(8),
  brand_name VARCHAR(200),
  descriptor VARCHAR(150),
  pediatric_flag TINYINT(1),
  accession_number VARCHAR(5),
  number_of_ais VARCHAR(10),
  last_update_date DATE,
  ai_group_no VARCHAR(10),
  PRIMARY KEY (id),
  KEY dk_brand_name ( brand_name ),
  KEY dk_categorization ( categorization ),
  KEY dk_class ( class ),
  KEY dk_number_of_ais ( number_of_ais )
) ENGINE=InnoDB CHARSET=utf8;

LOAD DATA LOCAL INFILE "enc_drug.txt"
INTO TABLE dp_product CHARACTER SET UTF8
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
( @col_0, @col_1, @col_2, @col_3, @col_4, @col_5, @col_6, @col_7, @col_8, @col_9, @col_a )
SET id = @col_0,
    categorization = NULLIF( @col_1, "" ),
    class = NULLIF( @col_2, "" ),
    din = NULLIF( @col_3, "" ),
    brand_name = NULLIF( @col_4, "" ),
    descriptor = NULLIF( @col_5, "" ),
    pediatric_flag = IF( ""=@col_6, NULL, IF( "Y"=@col_6, 1, 0 ) ),
    accession_number = NULLIF( @col_7, "" ),
    number_of_ais = NULLIF( @col_8, "" ),
    last_update_date = str_to_date( @col_9, "%d-%b-%Y" ),
    ai_group_no = NULLIF( REPLACE( @col_a, '"', '' ), "" );

LOAD DATA LOCAL INFILE "enc_drug_ap.txt"
INTO TABLE dp_product CHARACTER SET UTF8
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
( @col_0, @col_1, @col_2, @col_3, @col_4, @col_5, @col_6, @col_7, @col_8, @col_9, @col_a )
SET id = @col_0,
    categorization = NULLIF( @col_1, "" ),
    class = NULLIF( @col_2, "" ),
    din = NULLIF( IF( "Not Applicable/non applicable" = @col_3, NULL, @col_3 ), "" ),
    brand_name = NULLIF( @col_4, "" ),
    descriptor = NULLIF( @col_5, "" ),
    pediatric_flag = IF( ""=@col_6, NULL, IF( "Y"=@col_6, 1, 0 ) ),
    accession_number = NULLIF( @col_7, "" ),
    number_of_ais = NULLIF( @col_8, "" ),
    last_update_date = str_to_date( @col_9, "%d-%b-%Y" ),
    ai_group_no = NULLIF( REPLACE( @col_a, '"', '' ), "" );

LOAD DATA LOCAL INFILE "enc_drug_ia.txt"
INTO TABLE dp_product CHARACTER SET UTF8
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
( @col_0, @col_1, @col_2, @col_3, @col_4, @col_5, @col_6, @col_7, @col_8, @col_9, @col_a )
SET id = @col_0,
    categorization = NULLIF( @col_1, "" ),
    class = NULLIF( @col_2, "" ),
    din = NULLIF( @col_3, "" ),
    brand_name = NULLIF( @col_4, "" ),
    descriptor = NULLIF( @col_5, "" ),
    pediatric_flag = IF( ""=@col_6, NULL, IF( "Y"=@col_6, 1, 0 ) ),
    accession_number = NULLIF( @col_7, "" ),
    number_of_ais = NULLIF( @col_8, "" ),
    last_update_date = str_to_date( @col_9, "%d-%b-%Y" ),
    ai_group_no = NULLIF( REPLACE( @col_a, '"', '' ), "" );
