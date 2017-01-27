SELECT "Creating therapeutic_class table" AS "";

CREATE TABLE dp_therapeutic_class (
  dp_id INT NOT NULL,
  anumber VARCHAR(8),
  atc VARCHAR(120),
  ahfs_number VARCHAR(20),
  ahfs VARCHAR(80),
  KEY fk_dp_id (dp_id),
  KEY dk_atc ( atc ),
  KEY dk_ahfs ( ahfs ),
  CONSTRAINT fk_dp_therapeutic_class_dp_id FOREIGN KEY (dp_id)
  REFERENCES dp_product(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB CHARSET=utf8;

LOAD DATA LOCAL INFILE "enc_ther.txt"
INTO TABLE dp_therapeutic_class CHARACTER SET UTF8
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\n"
( @col_0, @col_1, @col_2, @col_3, @col_4 )
SET dp_id = @col_0,
    anumber = NULLIF( @col_1, "" ),
    atc = NULLIF( @col_2, "" ),
    ahfs_number = NULLIF( @col_3, "" ),
    ahfs = NULLIF( @col_4, "" );

LOAD DATA LOCAL INFILE "enc_ther_ap.txt"
INTO TABLE dp_therapeutic_class CHARACTER SET UTF8
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\n"
( @col_0, @col_1, @col_2, @col_3, @col_4 )
SET dp_id = @col_0,
    anumber = NULLIF( @col_1, "" ),
    atc = NULLIF( @col_2, "" ),
    ahfs_number = NULLIF( @col_3, "" ),
    ahfs = NULLIF( @col_4, "" );

LOAD DATA LOCAL INFILE "enc_ther_ia.txt"
INTO TABLE dp_therapeutic_class CHARACTER SET UTF8
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\n"
( @col_0, @col_1, @col_2, @col_3, @col_4 )
SET dp_id = @col_0,
    anumber = NULLIF( @col_1, "" ),
    atc = NULLIF( @col_2, "" ),
    ahfs_number = NULLIF( @col_3, "" ),
    ahfs = NULLIF( @col_4, "" );
