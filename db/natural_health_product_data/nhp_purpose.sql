SELECT "Creating purpose table" AS "";

DROP TABLE IF EXISTS nhp_purpose;
CREATE TABLE nhp_purpose (
  nhp_id INT(11),
  purpose_e VARCHAR(4000),
  purpose_french VARCHAR(4000),
  KEY fk_nhp_id (nhp_id),
  CONSTRAINT fk_nhp_purpose_nhp_id FOREIGN KEY (nhp_id)
  REFERENCES nhp_product(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB CHARSET=utf8;

LOAD DATA LOCAL INFILE "NHP_PRODUCTS_PURPOSE.txt"
INTO TABLE nhp_purpose
FIELDS TERMINATED BY "|" ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
( @col_0, @col_1, @col_2 )
SET nhp_id = @col_0,
    purpose_e = NULLIF( @col_1, "" ),
    purpose_french = NULLIF( @col_2, "" );
