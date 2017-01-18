SELECT "Creating drug_product table" AS "";

DROP TABLE IF EXISTS drug_product;
CREATE TABLE drug_product (
  drug_code INT NOT NULL,
  product_categorization VARCHAR(80),
  class VARCHAR(40),
  drug_identification_number VARCHAR(8),
  brand_name VARCHAR(200),
  descriptor VARCHAR(150),
  pediatric_flag VARCHAR(1),
  accession_number VARCHAR(5),
  number_of_ais VARCHAR(10),
  last_update_date DATE,
  ai_group_no VARCHAR(10),
  PRIMARY KEY (drug_code),
  KEY dk_brand_name ( brand_name ),
  KEY dk_product_categorization ( product_categorization ),
  KEY dk_class ( class ),
  KEY dk_pediatric_flag ( pediatric_flag ),
  KEY dk_number_of_ais ( number_of_ais )
) ENGINE=InnoDB CHARSET=utf8;

LOAD DATA LOCAL INFILE "drug.txt"
INTO TABLE drug_product
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
( @col_0, @col_1, @col_2, @col_3, @col_4, @col_5, @col_6, @col_7, @col_8, @col_9, @col_a )
SET drug_code = @col_0,
    product_categorization = NULLIF( @col_1, "" ),
    class = NULLIF( @col_2, "" ),
    drug_identification_number = NULLIF( @col_3, "" ),
    brand_name = NULLIF( @col_4, "" ),
    descriptor = NULLIF( @col_5, "" ),
    pediatric_flag = NULLIF( @col_6, "" ),
    accession_number = NULLIF( @col_7, "" ),
    number_of_ais = NULLIF( @col_8, "" ),
    last_update_date = str_to_date( @col_9, "%d-%b-%Y" ),
    ai_group_no = NULLIF( REPLACE( @col_a, '"', '' ), "" );

LOAD DATA LOCAL INFILE "drug_ap.txt"
INTO TABLE drug_product
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
( @col_0, @col_1, @col_2, @col_3, @col_4, @col_5, @col_6, @col_7, @col_8, @col_9, @col_a )
SET drug_code = @col_0,
    product_categorization = NULLIF( @col_1, "" ),
    class = NULLIF( @col_2, "" ),
    drug_identification_number = NULLIF( IF( "Not Applicable/non applicable" = @col_3, NULL, @col_3 ), "" ),
    brand_name = NULLIF( @col_4, "" ),
    descriptor = NULLIF( @col_5, "" ),
    pediatric_flag = NULLIF( @col_6, "" ),
    accession_number = NULLIF( @col_7, "" ),
    number_of_ais = NULLIF( @col_8, "" ),
    last_update_date = str_to_date( @col_9, "%d-%b-%Y" ),
    ai_group_no = NULLIF( REPLACE( @col_a, '"', '' ), "" );

LOAD DATA LOCAL INFILE "drug_ia.txt"
INTO TABLE drug_product
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
( @col_0, @col_1, @col_2, @col_3, @col_4, @col_5, @col_6, @col_7, @col_8, @col_9, @col_a )
SET drug_code = @col_0,
    product_categorization = NULLIF( @col_1, "" ),
    class = NULLIF( @col_2, "" ),
    drug_identification_number = NULLIF( @col_3, "" ),
    brand_name = NULLIF( @col_4, "" ),
    descriptor = NULLIF( @col_5, "" ),
    pediatric_flag = NULLIF( @col_6, "" ),
    accession_number = NULLIF( @col_7, "" ),
    number_of_ais = NULLIF( @col_8, "" ),
    last_update_date = str_to_date( @col_9, "%d-%b-%Y" ),
    ai_group_no = NULLIF( REPLACE( @col_a, '"', '' ), "" );
