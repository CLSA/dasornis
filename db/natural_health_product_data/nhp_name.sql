SELECT "Creating name table" AS "";

DROP TABLE IF EXISTS nhp_name;
CREATE TABLE nhp_name (
  nhp_id INT(11),
  name VARCHAR(200),
  main TINYINT(1),
  KEY fk_nhp_id (nhp_id),
  CONSTRAINT fk_nhp_name_nhp_id FOREIGN KEY (nhp_id)
  REFERENCES nhp_product(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB CHARSET=utf8;

LOAD DATA LOCAL INFILE "NHP_PRODUCT_NAMES.txt"
INTO TABLE nhp_name
FIELDS TERMINATED BY "|" ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
( @col_0, @col_1, @col_2 )
SET nhp_id = @col_0,
    name = NULLIF( @col_1, "" ),
    main = IF( ""=@col_2, NULL, IF( "Y"=@col_2, 1, 0 ) );
