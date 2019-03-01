-- This file will load all prematch data

SET CHARACTER SET 'utf8';
SET collation_connection = 'utf8_general_ci';

SELECT "Creating prematch table" AS "";

DROP TABLE IF EXISTS prematch;
CREATE TABLE prematch (
  match1 VARCHAR(127),
  match2 VARCHAR(127),
  match3 VARCHAR(127),
  match4 VARCHAR(127),
  match5 VARCHAR(127),
  din VARCHAR(8),
  npn VARCHAR(8),
  INDEX dk_match1( match1 ),
  INDEX dk_match2( match2 ),
  INDEX dk_match3( match3 ),
  INDEX dk_match4( match4 ),
  INDEX dk_match5( match5 )
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE "enc_prematch.csv"
INTO TABLE prematch CHARACTER SET UTF8
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\n"
IGNORE 1 LINES
( @col_0, @col_1, @col_2, @col_3, @col_4, @col_5, @col_6 )
SET match1 = @col_0, match2 = @col_1, match3 = @col_2, match4 = @col_3, match5 = @col_4, din = @col_5, npn = @col_6;
