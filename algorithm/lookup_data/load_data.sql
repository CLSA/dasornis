-- This file will load all lookup data

SET CHARACTER SET 'utf8';
SET collation_connection = 'utf8_general_ci';

SELECT "Creating lookup table" AS "";

DROP TABLE IF EXISTS lookup;
CREATE TABLE lookup (
  input VARCHAR(127),
  output VARCHAR(127),
  INDEX dk_input ( input )
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE "enc_lookup.csv"
INTO TABLE lookup CHARACTER SET UTF8
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\n"
IGNORE 1 LINES
( @col_0, @col_1 )
SET input = @col_0, output = @col_1;
