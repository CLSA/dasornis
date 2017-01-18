SELECT "Creating route table" AS "";

DROP TABLE IF EXISTS nhp_route;
CREATE TABLE nhp_route (
  nhp_id INT(11),
  route_type_desc VARCHAR(120),
  route_type_desc_french VARCHAR(120),
  KEY fk_nhp_id (nhp_id),
  CONSTRAINT fk_nhp_route_nhp_id FOREIGN KEY (nhp_id)
  REFERENCES nhp_product(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB CHARSET=utf8;

LOAD DATA LOCAL INFILE "NHP_ROUTE.txt"
INTO TABLE nhp_route
FIELDS TERMINATED BY "|" ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
( @col_0, @col_1, @col_2 )
SET nhp_id = @col_0,
    route_type_desc = NULLIF( @col_1, "" ),
    route_type_desc_french = NULLIF( @col_2, "" );
