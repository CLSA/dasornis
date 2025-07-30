-- This file will load all medication data stored in Opal

SET CHARACTER SET 'utf8';
SET collation_connection = 'utf8_general_ci';

SELECT "Creating data table" AS "";

DROP TABLE IF EXISTS data_has_din;
DROP TABLE IF EXISTS data_has_npn;
DROP TABLE IF EXISTS data;
CREATE TABLE data (
  identifier CHAR(10) NOT NULL,
  input VARCHAR(127) COMMENT "Opal variable: MEDI_ID_NAME_SP_1",
  PRIMARY KEY (identifier),
  INDEX dk_input ( input )
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE "enc_data.csv"
INTO TABLE data CHARACTER SET UTF8
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\n"
IGNORE 1 LINES
(@col_0, @col_1, @col_2)
SET
  identifier = CONCAT(
    REPEAT( "0", 7-CHAR_LENGTH( @col_0 ) ),
    @col_0,
    "-",
    REPEAT( "0", 2-CHAR_LENGTH( @col_1 ) ),
    @col_1
  ),
  input = IF( "" = @col_2, NULL, @col_2 );

SHOW WARNINGS;
SELECT COUNT(*) AS "Records Added" FROM data;
