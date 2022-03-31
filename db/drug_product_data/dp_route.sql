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

LOAD DATA LOCAL INFILE "enc_route.txt"
INTO TABLE dp_route CHARACTER SET UTF8
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\n"
( @col_0, @col_1, @col_2 )
SET dp_id = @col_0,
    code = NULLIF( @col_1, "" ),
    route = NULLIF( @col_2, "" );

LOAD DATA LOCAL INFILE "enc_route_ap.txt"
INTO TABLE dp_route CHARACTER SET UTF8
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\n"
( @col_0, @col_1, @col_2 )
SET dp_id = @col_0,
    code = NULLIF( @col_1, "" ),
    route = NULLIF( @col_2, "" );

LOAD DATA LOCAL INFILE "enc_route_ia.txt"
INTO TABLE dp_route CHARACTER SET UTF8
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\n"
( @col_0, @col_1, @col_2 )
SET dp_id = @col_0,
    code = NULLIF( @col_1, "" ),
    route = NULLIF( @col_2, "" );

LOAD DATA LOCAL INFILE "enc_route_dr.txt"
INTO TABLE dp_route CHARACTER SET UTF8
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\n"
( @col_0, @col_1, @col_2 )
SET dp_id = @col_0,
    code = NULLIF( @col_1, "" ),
    route = NULLIF( @col_2, "" );
