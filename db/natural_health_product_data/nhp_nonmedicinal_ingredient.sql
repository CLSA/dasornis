SELECT "Creating nonmedicinal_ingredient table" AS "";

DROP TABLE IF EXISTS nhp_nonmedicinal_ingredient;
CREATE TABLE nhp_nonmedicinal_ingredient (
  nhp_id INT(11),
  proper_name VARCHAR(200),
  proper_name_french VARCHAR(200),
  common_name VARCHAR(200),
  common_name_french VARCHAR(200),
  KEY fk_nhp_id (nhp_id),
  CONSTRAINT fk_nhp_nonmedicinal_ingredient_nhp_id FOREIGN KEY (nhp_id)
  REFERENCES nhp_product(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB CHARSET=utf8;

LOAD DATA LOCAL INFILE "NHP_NONMEDICINAL_INGREDIENTS.txt"
INTO TABLE nhp_nonmedicinal_ingredient
FIELDS TERMINATED BY "|" ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
( @col_0, @col_1, @col_2, @col_3, @col_4 )
SET nhp_id = @col_0,
    proper_name = NULLIF( @col_1, "" ),
    proper_name_french = NULLIF( @col_2, "" ),
    common_name = NULLIF( @col_3, "" ),
    common_name_french = NULLIF( @col_4, "" );
