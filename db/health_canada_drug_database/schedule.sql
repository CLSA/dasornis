SELECT "Creating schedule table" AS "";

DROP TABLE IF EXISTS schedule;
CREATE TABLE schedule (
  drug_code INT NOT NULL,
  schedule VARCHAR(40),
  KEY fk_drug_code (drug_code),
  KEY dk_schedule ( schedule ),
  CONSTRAINT fk_schedule_drug_code FOREIGN KEY (drug_code)
  REFERENCES drug_product(drug_code) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB CHARSET=utf8;

LOAD DATA LOCAL INFILE "schedule.txt"
INTO TABLE schedule
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
( @col_0, @col_1 )
SET drug_code = @col_0,
    schedule = NULLIF( @col_1, "" );

LOAD DATA LOCAL INFILE "schedule_ap.txt"
INTO TABLE schedule
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
( @col_0, @col_1 )
SET drug_code = @col_0,
    schedule = NULLIF( @col_1, "" );

LOAD DATA LOCAL INFILE "schedule_ia.txt"
INTO TABLE schedule
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
( @col_0, @col_1 )
SET drug_code = @col_0,
    schedule = NULLIF( @col_1, "" );
