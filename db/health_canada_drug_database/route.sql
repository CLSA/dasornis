SELECT "Creating route table" AS "";

DROP TABLE IF EXISTS route;
CREATE TABLE route (
  drug_code INT NOT NULL,
  route_of_administration_code INT,
  route_of_administration VARCHAR(40),
  KEY fk_drug_code (drug_code),
  KEY dk_route_of_administration ( route_of_administration ),
  CONSTRAINT fk_route_drug_code FOREIGN KEY (drug_code)
  REFERENCES drug_product(drug_code) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB CHARSET=utf8;

LOAD DATA LOCAL INFILE "route.txt"
INTO TABLE route
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
( @col_0, @col_1, @col_2 )
SET drug_code = @col_0,
    route_of_administration_code = NULLIF( @col_1, "" ),
    route_of_administration = NULLIF( @col_2, "" );

LOAD DATA LOCAL INFILE "route_ap.txt"
INTO TABLE route
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
( @col_0, @col_1, @col_2 )
SET drug_code = @col_0,
    route_of_administration_code = NULLIF( @col_1, "" ),
    route_of_administration = NULLIF( @col_2, "" );

LOAD DATA LOCAL INFILE "route_ia.txt"
INTO TABLE route
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
( @col_0, @col_1, @col_2 )
SET drug_code = @col_0,
    route_of_administration_code = NULLIF( @col_1, "" ),
    route_of_administration = NULLIF( @col_2, "" );
