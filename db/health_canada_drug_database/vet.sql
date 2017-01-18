SELECT "Creating veterinary_species table" AS "";

DROP TABLE IF EXISTS veterinary_species;
CREATE TABLE veterinary_species (
  drug_code INT NOT NULL,
  vet_species VARCHAR(80),
  vet_sub_species VARCHAR(80),
  KEY fk_drug_code (drug_code),
  CONSTRAINT fk_vet_drug_code FOREIGN KEY (drug_code)
  REFERENCES drug_product(drug_code) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB CHARSET=utf8;

LOAD DATA LOCAL INFILE "vet.txt"
INTO TABLE veterinary_species
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
( @col_0, @col_1, @col_2 )
SET drug_code = @col_0,
    vet_species = NULLIF( @col_1, "" ),
    vet_sub_species = NULLIF( @col_2, "" );

LOAD DATA LOCAL INFILE "vet_ap.txt"
INTO TABLE veterinary_species
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
( @col_0, @col_1, @col_2 )
SET drug_code = @col_0,
    vet_species = NULLIF( @col_1, "" ),
    vet_sub_species = NULLIF( @col_2, "" );

LOAD DATA LOCAL INFILE "vet_ia.txt"
INTO TABLE veterinary_species
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
( @col_0, @col_1, @col_2 )
SET drug_code = @col_0,
    vet_species = NULLIF( @col_1, "" ),
    vet_sub_species = NULLIF( @col_2, "" );
