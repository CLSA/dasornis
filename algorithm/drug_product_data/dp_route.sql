SELECT "Creating route table" AS "";

CREATE TABLE dp_route (
  dp_id INT NOT NULL,
  code INT,
  route VARCHAR(40),
  KEY fk_dp_id (dp_id),
  KEY dk_route ( route ),
  CONSTRAINT fk_dp_route_dp_id FOREIGN KEY (dp_id)
  REFERENCES dp_product(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB CHARSET=utf8;

SELECT "Loading route.txt" AS "";
LOAD DATA LOCAL INFILE "route.txt"
INTO TABLE dp_route CHARACTER SET UTF8
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
( @col_0, @col_1, @col_2, @col_3 )
SET dp_id = @col_0,
    code = NULLIF( @col_1, "" ),
    route = NULLIF( @col_2, "" );

SHOW WARNINGS;

SELECT "Loading route_ap.txt" AS "";
LOAD DATA LOCAL INFILE "route_ap.txt"
INTO TABLE dp_route CHARACTER SET UTF8
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
( @col_0, @col_1, @col_2, @col_3 )
SET dp_id = @col_0,
    code = NULLIF( @col_1, "" ),
    route = NULLIF( @col_2, "" );

SHOW WARNINGS;

SELECT "Loading route_ia.txt" AS "";
LOAD DATA LOCAL INFILE "route_ia.txt"
INTO TABLE dp_route CHARACTER SET UTF8
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
( @col_0, @col_1, @col_2, @col_3 )
SET dp_id = @col_0,
    code = NULLIF( @col_1, "" ),
    route = NULLIF( @col_2, "" );

SHOW WARNINGS;

SELECT "Loading route_dr.txt" AS "";
LOAD DATA LOCAL INFILE "route_dr.txt"
INTO TABLE dp_route CHARACTER SET UTF8
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
( @col_0, @col_1, @col_2, @col_3 )
SET dp_id = @col_0,
    code = NULLIF( @col_1, "" ),
    route = NULLIF( @col_2, "" );

SHOW WARNINGS;
