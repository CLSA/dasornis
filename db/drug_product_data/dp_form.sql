SELECT "Creating form table" AS "";

CREATE TABLE dp_form (
  dp_id INT NOT NULL,
  pharmaceutical_code INT,
  pharmaceutical_form VARCHAR(40),
  KEY fk_dp_id (dp_id),
  KEY dk_pharmaceutical_form ( pharmaceutical_form ),
  CONSTRAINT fk_dp_form_dp_id FOREIGN KEY (dp_id)
  REFERENCES dp_product(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB CHARSET=utf8;

LOAD DATA LOCAL INFILE "enc_form.txt"
INTO TABLE dp_form CHARACTER SET UTF8
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
( @col_0, @col_1, @col_2 )
SET dp_id = @col_0,
    pharmaceutical_code = NULLIF( @col_1, "" ),
    pharmaceutical_form = NULLIF( @col_2, "" );

LOAD DATA LOCAL INFILE "enc_form_ap.txt"
INTO TABLE dp_form CHARACTER SET UTF8
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
( @col_0, @col_1, @col_2 )
SET dp_id = @col_0,
    pharmaceutical_code = NULLIF( @col_1, "" ),
    pharmaceutical_form = NULLIF( @col_2, "" );

LOAD DATA LOCAL INFILE "enc_form_ia.txt"
INTO TABLE dp_form CHARACTER SET UTF8
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
( @col_0, @col_1, @col_2 )
SET dp_id = @col_0,
    pharmaceutical_code = NULLIF( @col_1, "" ),
    pharmaceutical_form = NULLIF( @col_2, "" );
