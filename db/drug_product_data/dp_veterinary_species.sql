SELECT "Creating veterinary_species table" AS "";

CREATE TABLE dp_veterinary_species (
  dp_id INT NOT NULL,
  species VARCHAR(80),
  sub_species VARCHAR(80),
  KEY fk_dp_id (dp_id),
  CONSTRAINT fk_dp_veterinary_species_dp_id FOREIGN KEY (dp_id)
  REFERENCES dp_product(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB CHARSET=utf8;

LOAD DATA LOCAL INFILE "enc_vet.txt"
INTO TABLE dp_veterinary_species CHARACTER SET UTF8
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
( @col_0, @col_1, @col_2 )
SET dp_id = @col_0,
    species = NULLIF( @col_1, "" ),
    sub_species = NULLIF( @col_2, "" );

LOAD DATA LOCAL INFILE "enc_vet_ap.txt"
INTO TABLE dp_veterinary_species CHARACTER SET UTF8
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
( @col_0, @col_1, @col_2 )
SET dp_id = @col_0,
    species = NULLIF( @col_1, "" ),
    sub_species = NULLIF( @col_2, "" );

LOAD DATA LOCAL INFILE "enc_vet_ia.txt"
INTO TABLE dp_veterinary_species CHARACTER SET UTF8
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
( @col_0, @col_1, @col_2 )
SET dp_id = @col_0,
    species = NULLIF( @col_1, "" ),
    sub_species = NULLIF( @col_2, "" );
