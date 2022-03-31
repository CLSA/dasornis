SELECT "Creating schedule table" AS "";

CREATE TABLE dp_schedule (
  dp_id INT NOT NULL,
  schedule VARCHAR(40),
  KEY fk_dp_id (dp_id),
  KEY dk_schedule ( schedule ),
  CONSTRAINT fk_dp_schedule_dp_id FOREIGN KEY (dp_id)
  REFERENCES dp_product(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB CHARSET=utf8;

LOAD DATA LOCAL INFILE "enc_schedule.txt"
INTO TABLE dp_schedule CHARACTER SET UTF8
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\n"
( @col_0, @col_1 )
SET dp_id = @col_0,
    schedule = NULLIF( @col_1, "" );

LOAD DATA LOCAL INFILE "enc_schedule_ap.txt"
INTO TABLE dp_schedule CHARACTER SET UTF8
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\n"
( @col_0, @col_1 )
SET dp_id = @col_0,
    schedule = NULLIF( @col_1, "" );

LOAD DATA LOCAL INFILE "enc_schedule_ia.txt"
INTO TABLE dp_schedule CHARACTER SET UTF8
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\n"
( @col_0, @col_1 )
SET dp_id = @col_0,
    schedule = NULLIF( @col_1, "" );

LOAD DATA LOCAL INFILE "enc_schedule_dr.txt"
INTO TABLE dp_schedule CHARACTER SET UTF8
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\n"
( @col_0, @col_1 )
SET dp_id = @col_0,
    schedule = NULLIF( @col_1, "" );
