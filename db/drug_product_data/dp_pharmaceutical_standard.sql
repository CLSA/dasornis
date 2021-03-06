SELECT "Creating pharmaceutical_standard table" AS "";

CREATE TABLE dp_pharmaceutical_standard (
  dp_id INT NOT NULL,
  standard VARCHAR(40),
  KEY fk_dp_id (dp_id),
  KEY dk_standard ( standard ),
  CONSTRAINT fk_dp_pharmaceutical_standard_dp_id FOREIGN KEY (dp_id)
  REFERENCES dp_product(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB CHARSET=utf8;

LOAD DATA LOCAL INFILE "enc_pharm.txt"
INTO TABLE dp_pharmaceutical_standard CHARACTER SET UTF8
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\n"
( @col_0, @col_1 )
SET dp_id = @col_0,
    standard = NULLIF( @col_1, "" );

LOAD DATA LOCAL INFILE "enc_pharm_ap.txt"
INTO TABLE dp_pharmaceutical_standard CHARACTER SET UTF8
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\n"
( @col_0, @col_1 )
SET dp_id = @col_0,
    standard = NULLIF( @col_1, "" );

LOAD DATA LOCAL INFILE "enc_pharm_ia.txt"
INTO TABLE dp_pharmaceutical_standard CHARACTER SET UTF8
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\n"
( @col_0, @col_1 )
SET dp_id = @col_0,
    standard = NULLIF( @col_1, "" );

LOAD DATA LOCAL INFILE "enc_pharm_dr.txt"
INTO TABLE dp_pharmaceutical_standard CHARACTER SET UTF8
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\n"
( @col_0, @col_1 )
SET dp_id = @col_0,
    standard = NULLIF( @col_1, "" );
