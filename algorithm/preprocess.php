#!/usr/bin/php
<?php
require_once( 'database.php' );

///////////////////////////////////////////////////////////////////////////////////////////////////
print "Creating auxiliry tables\n";

$db->query( 'DROP TABLE IF EXISTS data_has_din' );

$db->query( <<<SQL
  CREATE TABLE data_has_din (
    identifier char(10) NOT NULL,
    din varchar(8) NOT NULL,
    type ENUM( "manual-match", "pre-match", "direct", "code", "word", "reverse-word", "simple", "no-parens", "no-units", "no-vowel", "soundex" ),
    source ENUM( "pre-match", "code", "product", "ingredient" ) NOT NULL,
    PRIMARY KEY (identifier, din),
    INDEX fk_identifier (identifier),
    INDEX fk_din (din),
    INDEX dk_type (type),
    INDEX dk_source (source),
    CONSTRAINT fk_data_has_din_identifier
      FOREIGN KEY (identifier)
      REFERENCES data (identifier)
      ON DELETE CASCADE
      ON UPDATE CASCADE
  ) ENGINE = InnoDB CHARSET=utf8
SQL );

$db->query( 'DROP TABLE IF EXISTS data_has_npn' );

$db->query( <<<SQL
  CREATE TABLE data_has_npn (
    identifier char(10) NOT NULL,
    npn varchar(8) NOT NULL,
    type ENUM( "manual-match", "pre-match", "direct", "code", "word", "reverse-word", "simple", "no-parens", "no-units", "no-vowel", "soundex" ),
    source ENUM( "pre-match", "code", "product", "ingredient", "common" ) NOT NULL,
    PRIMARY KEY (identifier, npn),
    INDEX fk_identifier (identifier),
    INDEX fk_npn (npn),
    INDEX dk_type (type),
    INDEX dk_source (source),
    CONSTRAINT fk_data_has_npn_identifier
      FOREIGN KEY (identifier)
      REFERENCES data (identifier)
      ON DELETE CASCADE
      ON UPDATE CASCADE
  ) ENGINE = InnoDB CHARSET=utf8
SQL );

///////////////////////////////////////////////////////////////////////////////////////////////////
print "Creating drug_name table\n";

$db->query( 'DROP TABLE IF EXISTS drug_name' );

$db->query( <<<SQL
  CREATE TABLE drug_name (
    PRIMARY KEY (name),
    INDEX dk_din (din)
  )
  SELECT brand_name AS name, MIN( din ) AS din
  FROM dp_product
  WHERE brand_name IS NOT NULL
  GROUP BY brand_name
SQL );

$db->query( <<<SQL
  ALTER TABLE drug_name
  ADD COLUMN name_simple VARCHAR(200) NULL DEFAULT NULL,
  ADD COLUMN name_no_parens VARCHAR(200) NULL DEFAULT NULL,
  ADD COLUMN name_no_units VARCHAR(200) NULL DEFAULT NULL,
  ADD INDEX dk_name_simple ( name_simple ),
  ADD INDEX dk_name_no_parens ( name_no_parens ),
  ADD INDEX dk_name_no_units ( name_no_units )
SQL );

$data = '';
$result = $db->query( 'SELECT name FROM drug_name' );
while( $row = $result->fetch_row() ) if( $row[0] ) {
  $data .= sprintf(
    '"%s","%s","%s","%s"'."\n",
    $row[0],
    preg_replace( '/[^a-z0-9]/', '', strtolower( $row[0] ) ),
    preg_replace( '/ *\([^)]+\)/', '', strtolower( $row[0] ) ),
    trim( preg_replace(
      array_reverse( array(
        '/ *\(?[0-9.,:;\-\/ ]+ ?mm\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?mg\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?mg\/g\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?mg\/ml\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?mg\/[0-9.,:;\-\/ ]+ ?ml\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?mcg\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?mcg\/ml\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?ml\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?u\/ml\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?bau\/ml\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?au\/ml\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?i\.?u\.?\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?u\.?i\.?\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?unit\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?unit\/ml\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?unit\/vial\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?g\/vial\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?diskus\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?usp\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?spf\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?gm\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?gr\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?[cd]h ?- ?[0-9.,:;\-\/ ]+ ?[cd]h\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?x ?- ?c[0-9.,:;\-\/ ]+ ?\)?/'
      ) ), '', strtolower( $row[0] )
    ) )
  );
}
$result->free();
file_put_contents( 'temp_drug_name.csv', $data );

$db->query( <<<SQL
  CREATE TEMPORARY TABLE temp_drug_name (
    name CHAR(200) NOT NULL,
    name_simple VARCHAR(511),
    name_no_parens VARCHAR(511),
    name_no_units VARCHAR(511),
    PRIMARY KEY (name),
    INDEX dk_name_simple ( name_simple ),
    INDEX dk_name_no_parens ( name_no_parens ),
    INDEX dk_name_no_units ( name_no_units )
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8
SQL );
$db->query( <<<SQL
  LOAD DATA LOCAL INFILE "temp_drug_name.csv"
  INTO TABLE temp_drug_name
  FIELDS TERMINATED BY "," ENCLOSED BY '"'
  LINES TERMINATED BY "\n";
SQL );
$result = $db->query( <<<SQL
  UPDATE drug_name
  JOIN temp_drug_name USING( name )
  SET
    drug_name.name_simple = temp_drug_name.name_simple,
    drug_name.name_no_parens = temp_drug_name.name_no_parens,
    drug_name.name_no_units = temp_drug_name.name_no_units
SQL );

unlink( 'temp_drug_name.csv' );

///////////////////////////////////////////////////////////////////////////////////////////////////
print "Creating drug_ingredient_name table\n";

$db->query( 'DROP TABLE IF EXISTS drug_ingredient_name' );

$db->query( <<<SQL
  CREATE TABLE drug_ingredient_name (
    PRIMARY KEY (name),
    INDEX dk_din (din)
  )
  SELECT ingredient AS name, MIN( din ) AS din
  FROM dp_active_ingredient
  JOIN dp_product ON dp_active_ingredient.dp_id = dp_product.id
  WHERE din IS NOT NULL
  GROUP BY ingredient
SQL );

$db->query( <<<SQL
  ALTER TABLE drug_ingredient_name
  ADD COLUMN name_simple VARCHAR(200) NULL DEFAULT NULL,
  ADD COLUMN name_no_parens VARCHAR(200) NULL DEFAULT NULL,
  ADD COLUMN name_no_units VARCHAR(200) NULL DEFAULT NULL,
  ADD INDEX dk_name_simple ( name_simple ),
  ADD INDEX dk_name_no_parens ( name_no_parens ),
  ADD INDEX dk_name_no_units ( name_no_units )
SQL );

$data = '';
$result = $db->query( 'SELECT name FROM drug_ingredient_name' );
while( $row = $result->fetch_row() ) if( $row[0] ) {
  $data .= sprintf(
    '"%s","%s","%s","%s"'."\n",
    $row[0],
    preg_replace( '/[^a-z0-9]/', '', strtolower( $row[0] ) ),
    preg_replace( '/ *\([^)]+\)/', '', strtolower( $row[0] ) ),
    trim( preg_replace(
      array_reverse( array(
        '/ *\(?[0-9.,:;\-\/ ]+ ?mm\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?mg\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?mg\/g\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?mg\/ml\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?mg\/[0-9.,:;\-\/ ]+ ?ml\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?mcg\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?mcg\/ml\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?ml\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?u\/ml\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?bau\/ml\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?au\/ml\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?i\.?u\.?\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?u\.?i\.?\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?unit\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?unit\/ml\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?unit\/vial\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?g\/vial\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?diskus\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?usp\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?spf\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?gm\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?gr\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?[cd]h ?- ?[0-9.,:;\-\/ ]+ ?[cd]h\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?x ?- ?c[0-9.,:;\-\/ ]+ ?\)?/'
      ) ), '', strtolower( $row[0] )
    ) )
  );
}
$result->free();
file_put_contents( 'temp_drug_ingredient_name.csv', $data );

$db->query( <<<SQL
  CREATE TEMPORARY TABLE temp_drug_ingredient_name (
    name CHAR(200) NOT NULL,
    name_simple VARCHAR(511),
    name_no_parens VARCHAR(511),
    name_no_units VARCHAR(511),
    PRIMARY KEY (name),
    INDEX dk_name_simple ( name_simple ),
    INDEX dk_name_no_parens ( name_no_parens ),
    INDEX dk_name_no_units ( name_no_units )
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8
SQL );
$db->query( <<<SQL
  LOAD DATA LOCAL INFILE "temp_drug_ingredient_name.csv"
  INTO TABLE temp_drug_ingredient_name
  FIELDS TERMINATED BY "," ENCLOSED BY '"'
  LINES TERMINATED BY "\n"
SQL );
$result = $db->query( <<<SQL
  UPDATE drug_ingredient_name
  JOIN temp_drug_ingredient_name USING( name )
  SET
    drug_ingredient_name.name_simple = temp_drug_ingredient_name.name_simple,
    drug_ingredient_name.name_no_parens = temp_drug_ingredient_name.name_no_parens,
    drug_ingredient_name.name_no_units = temp_drug_ingredient_name.name_no_units
SQL );

unlink( 'temp_drug_ingredient_name.csv' );

///////////////////////////////////////////////////////////////////////////////////////////////////
print "Creating natural_name table\n";

$db->query( 'DROP TABLE IF EXISTS natural_name' );

$db->query( <<<SQL
  CREATE TABLE natural_name (
    PRIMARY KEY (name),
    INDEX dk_npn (npn)
  )
  SELECT product_name AS name, MIN( npn ) AS npn
  FROM lnhpd_product
  WHERE product_name IS NOT NULL
  GROUP BY product_name
SQL );

$db->query( <<<SQL
  ALTER TABLE natural_name
  ADD COLUMN name_simple VARCHAR(200) NULL DEFAULT NULL,
  ADD COLUMN name_no_parens VARCHAR(200) NULL DEFAULT NULL,
  ADD COLUMN name_no_units VARCHAR(200) NULL DEFAULT NULL,
  ADD INDEX dk_name_simple ( name_simple ),
  ADD INDEX dk_name_no_parens ( name_no_parens ),
  ADD INDEX dk_name_no_units ( name_no_units )
SQL );

$data = '';
$result = $db->query( 'SELECT name FROM natural_name' );
while( $row = $result->fetch_row() ) if( $row[0] ) {
  $data .= sprintf(
    '"%s","%s","%s","%s"'."\n",
    $row[0],
    preg_replace( '/[^a-z0-9]/', '', strtolower( $row[0] ) ),
    preg_replace( '/ *\([^)]+\)/', '', strtolower( $row[0] ) ),
    trim( preg_replace(
      array_reverse( array(
        '/ *\(?[0-9.,:;\-\/ ]+ ?mm\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?mg\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?mg\/g\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?mg\/ml\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?mg\/[0-9.,:;\-\/ ]+ ?ml\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?mcg\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?mcg\/ml\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?ml\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?u\/ml\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?bau\/ml\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?au\/ml\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?i\.?u\.?\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?u\.?i\.?\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?unit\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?unit\/ml\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?unit\/vial\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?g\/vial\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?diskus\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?usp\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?spf\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?gm\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?gr\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?[cd]h ?- ?[0-9.,:;\-\/ ]+ ?[cd]h\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?x ?- ?c[0-9.,:;\-\/ ]+ ?\)?/'
      ) ), '', strtolower( $row[0] )
    ) )
  );
}
$result->free();
file_put_contents( 'temp_natural_name.csv', $data );

$db->query( <<<SQL
  CREATE TEMPORARY TABLE temp_natural_name (
    name CHAR(200) NOT NULL,
    name_simple VARCHAR(511),
    name_no_parens VARCHAR(511),
    name_no_units VARCHAR(511),
    PRIMARY KEY (name),
    INDEX dk_name_simple ( name_simple ),
    INDEX dk_name_no_parens ( name_no_parens ),
    INDEX dk_name_no_units ( name_no_units )
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8
SQL );
$db->query( <<<SQL
  LOAD DATA LOCAL INFILE "temp_natural_name.csv"
  INTO TABLE temp_natural_name
  FIELDS TERMINATED BY "," ENCLOSED BY '"'
  LINES TERMINATED BY "\n";
SQL );
$result = $db->query( <<<SQL
  UPDATE natural_name
  JOIN temp_natural_name USING( name )
  SET
    natural_name.name_simple = temp_natural_name.name_simple,
    natural_name.name_no_parens = temp_natural_name.name_no_parens,
    natural_name.name_no_units = temp_natural_name.name_no_units
SQL );

unlink( 'temp_natural_name.csv' );

///////////////////////////////////////////////////////////////////////////////////////////////////
print "Creating natural_ingredient_name table\n";

$db->query( 'DROP TABLE IF EXISTS natural_ingredient_name' );

$db->query( <<<SQL
  CREATE TABLE natural_ingredient_name (
    PRIMARY KEY (name),
    INDEX dk_npn (npn)
  )
  SELECT name, MIN( npn ) AS npn
  FROM lnhpd_ingredient
  JOIN lnhpd_product USING ( lnhpd_id )
  WHERE name IS NOT NULL
  GROUP BY name
SQL );

$db->query( <<<SQL
  ALTER TABLE natural_ingredient_name
  ADD COLUMN name_simple VARCHAR(200) NULL DEFAULT NULL,
  ADD COLUMN name_no_parens VARCHAR(200) NULL DEFAULT NULL,
  ADD COLUMN name_no_units VARCHAR(200) NULL DEFAULT NULL,
  ADD INDEX dk_name_simple ( name_simple ),
  ADD INDEX dk_name_no_parens ( name_no_parens ),
  ADD INDEX dk_name_no_units ( name_no_units )
SQL );

$data = '';
$result = $db->query( 'SELECT name FROM natural_ingredient_name' );
while( $row = $result->fetch_row() ) if( $row[0] ) {
  $data .= sprintf(
    '"%s","%s","%s","%s"'."\n",
    $row[0],
    preg_replace( '/[^a-z0-9]/', '', strtolower( $row[0] ) ),
    preg_replace( '/ *\([^)]+\)/', '', strtolower( $row[0] ) ),
    trim( preg_replace(
      array_reverse( array(
        '/ *\(?[0-9.,:;\-\/ ]+ ?mm\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?mg\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?mg\/g\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?mg\/ml\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?mg\/[0-9.,:;\-\/ ]+ ?ml\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?mcg\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?mcg\/ml\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?ml\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?u\/ml\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?bau\/ml\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?au\/ml\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?i\.?u\.?\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?u\.?i\.?\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?unit\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?unit\/ml\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?unit\/vial\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?g\/vial\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?diskus\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?usp\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?spf\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?gm\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?gr\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?[cd]h ?- ?[0-9.,:;\-\/ ]+ ?[cd]h\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?x ?- ?c[0-9.,:;\-\/ ]+ ?\)?/'
      ) ), '', strtolower( $row[0] )
    ) )
  );
}
$result->free();
file_put_contents( 'temp_natural_ingredient_name.csv', $data );

$db->query( <<<SQL
  CREATE TEMPORARY TABLE temp_natural_ingredient_name (
    name CHAR(200) NOT NULL,
    name_simple VARCHAR(511),
    name_no_parens VARCHAR(511),
    name_no_units VARCHAR(511),
    PRIMARY KEY (name),
    INDEX dk_name_simple ( name_simple ),
    INDEX dk_name_no_parens ( name_no_parens ),
    INDEX dk_name_no_units ( name_no_units )
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8
SQL );
$db->query( <<<SQL
  LOAD DATA LOCAL INFILE "temp_natural_ingredient_name.csv"
  INTO TABLE temp_natural_ingredient_name
  FIELDS TERMINATED BY "," ENCLOSED BY '"'
  LINES TERMINATED BY "\n"
SQL );
$result = $db->query( <<<SQL
  UPDATE natural_ingredient_name
  JOIN temp_natural_ingredient_name USING( name )
  SET
    natural_ingredient_name.name_simple = temp_natural_ingredient_name.name_simple,
    natural_ingredient_name.name_no_parens = temp_natural_ingredient_name.name_no_parens,
    natural_ingredient_name.name_no_units = temp_natural_ingredient_name.name_no_units
SQL );

unlink( 'temp_natural_ingredient_name.csv' );

///////////////////////////////////////////////////////////////////////////////////////////////////
print "Adding helper columns to data table\n";

$result = $db->query( <<<SQL
  SELECT column_name
  FROM information_schema.columns
  WHERE table_schema = DATABASE()
  AND table_name = "data"
  AND column_name IN (
    "match_found", "input_code", "input_corrected", "input_simple", "input_no_parens", "input_no_units"
  )
SQL );

while( $row = $result->fetch_row() ) {
  $db->query( sprintf( 'ALTER TABLE data DROP INDEX dk_%s', $row[0] ) );
  $db->query( sprintf( 'ALTER TABLE data DROP COLUMN %s', $row[0] ) );
}

$db->query( <<<SQL
  ALTER TABLE data
  ADD COLUMN match_found TINYINT(1) NOT NULL DEFAULT 0,
  ADD COLUMN input_code VARCHAR(10) DEFAULT NULL,
  ADD COLUMN input_corrected VARCHAR(511) DEFAULT NULL,
  ADD COLUMN input_simple VARCHAR(511) DEFAULT NULL,
  ADD COLUMN input_no_parens VARCHAR(511) DEFAULT NULL,
  ADD COLUMN input_no_units VARCHAR(511) DEFAULT NULL,
  ADD INDEX dk_match_found ( match_found ),
  ADD INDEX dk_input_code ( input_code ),
  ADD INDEX dk_input_corrected ( input_corrected ),
  ADD INDEX dk_input_simple ( input_simple ),
  ADD INDEX dk_input_no_parens ( input_no_parens ),
  ADD INDEX dk_input_no_units ( input_no_units )
SQL );

$data = '';
$result = $db->query( <<<SQL
  SELECT
     identifier,
     IFNULL(
       REPLACE( LOWER( data.input ), word_correction.input, word_correction.output ),
       LOWER( data.input )
     )
  FROM data
  LEFT JOIN word_correction
    ON LOWER( data.input ) RLIKE CONCAT( "[[:<:]]", LOWER( word_correction.input ), "[[:>:]]" )
  WHERE data.input IS NOT NULL
SQL );
while( $row = $result->fetch_row() ) if( $row[0] && $row[1] ) {
  $input = str_replace( '"', '\"', $row[1] );
  $matches = array();
  preg_match( "/[0-9]{6,}/", $input, $matches );
  $code = 0 < count( $matches ) ? str_pad( $matches[0], 8, "0", STR_PAD_LEFT ) : NULL;
  $data .= sprintf(
    0 < count( $matches ) ?
      '"%s",%s,NULL,NULL,NULL,NULL'."\n" :
      '"%s",%s,"%s","%s","%s","%s"'."\n",
    $row[0],
    is_null( $code ) ? 'NULL' : '"'.$code.'"',
    $input,
    preg_replace( '/[^a-z0-9]/', '', $input ),
    preg_replace( '/ *\([^)]+\)/', '', $input ),
    trim( preg_replace(
      array_reverse( array(
        '/ *\(?[0-9.,:;\-\/ ]+ ?mm\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?mg\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?mg\/g\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?mg\/ml\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?mg\/[0-9.,:;\-\/ ]+ ?ml\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?mcg\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?mcg\/ml\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?ml\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?u\/ml\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?bau\/ml\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?au\/ml\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?i\.?u\.?\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?u\.?i\.?\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?unit\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?unit\/ml\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?unit\/vial\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?g\/vial\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?diskus\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?usp\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?spf\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?gm\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?gr\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?[cd]h ?- ?[0-9.,:;\-\/ ]+ ?[cd]h\)?/',
        '/ *\(?[0-9.,:;\-\/ ]+ ?x ?- ?c[0-9.,:;\-\/ ]+ ?\)?/'
      ) ), '', $input
    ) )
  );
}
$result->free();
file_put_contents( 'temp_data.csv', $data );

$db->query( <<<SQL
  CREATE TEMPORARY TABLE temp_data (
    identifier CHAR(10) NOT NULL,
    input_code VARCHAR(10),
    input_corrected VARCHAR(511),
    input_simple VARCHAR(511),
    input_no_parens VARCHAR(511),
    input_no_units VARCHAR(511),
    PRIMARY KEY (identifier),
    INDEX dk_input_code ( input_code ),
    INDEX dk_input_corrected ( input_corrected ),
    INDEX dk_input_simple ( input_simple ),
    INDEX dk_input_no_parens ( input_no_parens ),
    INDEX dk_input_no_units ( input_no_units )
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8
SQL );
$db->query( <<<SQL
  LOAD DATA LOCAL INFILE "temp_data.csv"
  INTO TABLE temp_data
  FIELDS TERMINATED BY "," ENCLOSED BY '"'
  LINES TERMINATED BY "\n"
SQL );
$result = $db->query( <<<SQL
  UPDATE data
  JOIN temp_data USING( identifier )
  SET
    data.input_code = temp_data.input_code,
    data.input_corrected = temp_data.input_corrected,
    data.input_simple = temp_data.input_simple,
    data.input_no_parens = temp_data.input_no_parens,
    data.input_no_units = temp_data.input_no_units
SQL );

unlink( 'temp_data.csv' );
