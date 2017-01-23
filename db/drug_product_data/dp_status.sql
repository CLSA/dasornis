SELECT "Creating status table" AS "";

CREATE TABLE dp_status (
  dp_id INT NOT NULL,
  current_status_flag TINYINT(1),
  status VARCHAR(40),
  history_date DATE,
  KEY fk_dp_id (dp_id),
  CONSTRAINT fk_dp_status_dp_id FOREIGN KEY (dp_id)
  REFERENCES dp_product(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB CHARSET=utf8;

LOAD DATA LOCAL INFILE "enc_status.txt"
INTO TABLE dp_status CHARACTER SET UTF8
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
( @col_0, @col_1, @col_2, @col_3 )
SET dp_id = @col_0,
    current_status_flag = IF( ""=@col_1, NULL, IF( "Y"=@col_1, 1, 0 ) ),
    status = NULLIF( @col_2, "" ),
    history_date = str_to_date( @col_3, "%d-%b-%Y" );

LOAD DATA LOCAL INFILE "enc_status_ap.txt"
INTO TABLE dp_status CHARACTER SET UTF8
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
( @col_0, @col_1, @col_2, @col_3 )
SET dp_id = @col_0,
    current_status_flag = IF( ""=@col_1, NULL, IF( "Y"=@col_1, 1, 0 ) ),
    status = NULLIF( @col_2, "" ),
    history_date = str_to_date( @col_3, "%d-%b-%Y" );

LOAD DATA LOCAL INFILE "enc_status_ia.txt"
INTO TABLE dp_status CHARACTER SET UTF8
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
( @col_0, @col_1, @col_2, @col_3 )
SET dp_id = @col_0,
    current_status_flag = IF( ""=@col_1, NULL, IF( "Y"=@col_1, 1, 0 ) ),
    status = NULLIF( @col_2, "" ),
    history_date = str_to_date( @col_3, "%d-%b-%Y" );
