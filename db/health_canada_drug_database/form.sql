SELECT "Creating form table" AS "";

DROP TABLE IF EXISTS form;
CREATE TABLE form (
  drug_code INT NOT NULL,
  pharm_form_code INT,
  pharmaceutical_form VARCHAR(40),
  KEY fk_drug_code (drug_code),
  KEY dk_pharmaceutical_form ( pharmaceutical_form ),
  CONSTRAINT fk_form_drug_code FOREIGN KEY (drug_code)
  REFERENCES drug_product(drug_code) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB CHARSET=utf8;

LOAD DATA LOCAL INFILE "form.txt"
INTO TABLE form
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
( @col_0, @col_1, @col_2 )
SET drug_code = @col_0,
    pharm_form_code = NULLIF( @col_1, "" ),
    pharmaceutical_form = NULLIF( @col_2, "" );

LOAD DATA LOCAL INFILE "form_ap.txt"
INTO TABLE form
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
( @col_0, @col_1, @col_2 )
SET drug_code = @col_0,
    pharm_form_code = NULLIF( @col_1, "" ),
    pharmaceutical_form = NULLIF( @col_2, "" );

LOAD DATA LOCAL INFILE "form_ia.txt"
INTO TABLE form
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
( @col_0, @col_1, @col_2 )
SET drug_code = @col_0,
    pharm_form_code = NULLIF( @col_1, "" ),
    pharmaceutical_form = NULLIF( @col_2, "" );
