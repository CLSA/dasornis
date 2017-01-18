SELECT "Creating status table" AS "";

DROP TABLE IF EXISTS status;
CREATE TABLE status (
  drug_code INT NOT NULL,
  current_status_flag VARCHAR(1),
  status VARCHAR(40),
  history_date DATE,
  KEY fk_drug_code (drug_code),
  CONSTRAINT fk_status_drug_code FOREIGN KEY (drug_code)
  REFERENCES drug_product(drug_code) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB CHARSET=utf8;

LOAD DATA LOCAL INFILE "status.txt"
INTO TABLE status
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
( @col_0, @col_1, @col_2, @col_3 )
SET drug_code = @col_0,
    current_status_flag = NULLIF( @col_1, "" ),
    status = NULLIF( @col_2, "" ),
    history_date = str_to_date( @col_3, "%d-%b-%Y" );

LOAD DATA LOCAL INFILE "status_ap.txt"
INTO TABLE status
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
( @col_0, @col_1, @col_2, @col_3 )
SET drug_code = @col_0,
    current_status_flag = NULLIF( @col_1, "" ),
    status = NULLIF( @col_2, "" ),
    history_date = str_to_date( @col_3, "%d-%b-%Y" );

LOAD DATA LOCAL INFILE "status_ia.txt"
INTO TABLE status
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
( @col_0, @col_1, @col_2, @col_3 )
SET drug_code = @col_0,
    current_status_flag = NULLIF( @col_1, "" ),
    status = NULLIF( @col_2, "" ),
    history_date = str_to_date( @col_3, "%d-%b-%Y" );
