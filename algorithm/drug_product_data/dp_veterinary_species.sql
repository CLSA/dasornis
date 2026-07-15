SELECT "Creating veterinary_species table" AS "";

CREATE TABLE dp_veterinary_species (
  dp_id INT NOT NULL,
  species VARCHAR(80),
  sub_species VARCHAR(80),
  KEY fk_dp_id (dp_id),
  CONSTRAINT fk_dp_veterinary_species_dp_id FOREIGN KEY (dp_id)
  REFERENCES dp_product(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB CHARSET=utf8;

SELECT "Loading vet.txt" AS "";
LOAD DATA LOCAL INFILE "vet.txt"
INTO TABLE dp_veterinary_species CHARACTER SET UTF8
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
( @col_0, @col_1, @col_2, @col_3 )
SET dp_id = @col_0,
    species = NULLIF( @col_1, "" ),
    sub_species = NULLIF( @col_2, "" );

SHOW WARNINGS;

SELECT "Loading vet_ap.txt" AS "";
LOAD DATA LOCAL INFILE "vet_ap.txt"
INTO TABLE dp_veterinary_species CHARACTER SET UTF8
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
( @col_0, @col_1, @col_2, @col_3 )
SET dp_id = @col_0,
    species = NULLIF( @col_1, "" ),
    sub_species = NULLIF( @col_2, "" );

SHOW WARNINGS;

SELECT "Loading vet_ia.txt" AS "";
LOAD DATA LOCAL INFILE "vet_ia.txt"
INTO TABLE dp_veterinary_species CHARACTER SET UTF8
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
( @col_0, @col_1, @col_2, @col_3 )
SET dp_id = @col_0,
    species = NULLIF( @col_1, "" ),
    sub_species = NULLIF( @col_2, "" );

SHOW WARNINGS;

SELECT "Loading vet_dr.txt" AS "";
LOAD DATA LOCAL INFILE "vet_dr.txt"
INTO TABLE dp_veterinary_species CHARACTER SET UTF8
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
( @col_0, @col_1, @col_2, @col_3 )
SET dp_id = @col_0,
    species = NULLIF( @col_1, "" ),
    sub_species = NULLIF( @col_2, "" );

SHOW WARNINGS;
