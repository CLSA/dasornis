SELECT "Creating company table" AS "";

DROP TABLE IF EXISTS nhp_company;
CREATE TABLE nhp_company (
  nhp_id INT(11),
  company_name VARCHAR(200),
  address VARCHAR(120),
  city VARCHAR(40),
  province VARCHAR(40),
  country VARCHAR(40),
  postal_code VARCHAR(40),
  KEY fk_nhp_id (nhp_id),
  CONSTRAINT fk_nhp_company_nhp_id FOREIGN KEY (nhp_id)
  REFERENCES nhp_product(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB CHARSET=utf8;

LOAD DATA LOCAL INFILE "NHP_COMPANIES.txt"
INTO TABLE nhp_company
FIELDS TERMINATED BY "|" ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
( @col_0, @col_1, @col_2, @col_3, @col_4, @col_5, @col_6 )
SET nhp_id = @col_0,
    company_name = NULLIF( @col_1, "" ),
    address = NULLIF( @col_2, "" ),
    city = NULLIF( @col_3, "" ),
    province = NULLIF( @col_4, "" ),
    country = NULLIF( @col_5, "" ),
    postal_code = NULLIF( @col_6, "" );
