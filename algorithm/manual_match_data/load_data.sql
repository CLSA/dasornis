-- This file will load all manual_match data

SET CHARACTER SET 'utf8';
SET collation_connection = 'utf8_general_ci';

SELECT "Creating manual_match table" AS "";

DROP TABLE IF EXISTS manual_match;
CREATE TABLE manual_match (
  input VARCHAR(511),
  din VARCHAR(8),
  npn VARCHAR(8),
  INDEX dk_input( input )
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE "enc_manual_match.csv"
INTO TABLE manual_match CHARACTER SET UTF8
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\n"
IGNORE 1 LINES
( @col_0, @col_1, @col_2 )
SET input = @col_0, din = @col_1, npn = @col_2;
