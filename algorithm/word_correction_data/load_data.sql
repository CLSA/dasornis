-- This file will load all word_correction data

SET CHARACTER SET 'utf8';
SET collation_connection = 'utf8_general_ci';

SELECT "Creating word_correction table" AS "";

DROP TABLE IF EXISTS word_correction;
CREATE TABLE word_correction (
  input VARCHAR(511),
  output VARCHAR(511),
  INDEX dk_input ( input )
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE "enc_word_correction.csv"
INTO TABLE word_correction CHARACTER SET UTF8
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\n"
IGNORE 1 LINES
( @col_0, @col_1 )
SET input = @col_0, output = @col_1;
