#!/usr/bin/php
<?php
require_once( 'database.php' );

///////////////////////////////////////////////////////////////////////////////////////////////////
print "Creating auxiliry tables\n";

$db->query( 'DROP TABLE IF EXISTS data_has_dp_product' );

$db->query(
  'CREATE TABLE data_has_dp_product ( '.
    'uid char(7) NOT NULL, '.
    'dp_id int(11) NOT NULL, '.
    'type ENUM( "direct", "code", "word", "reverse-word", "simple", "no-vowel", "soundex" ), '.
    'PRIMARY KEY (uid, dp_id), '.
    'INDEX fk_uid (uid), '.
    'INDEX fk_dp_id (dp_id), '.
    'INDEX dk_type (type), '.
    'CONSTRAINT fk_data_has_dp_product_uid '.
      'FOREIGN KEY (uid) '.
      'REFERENCES data (uid) '.
      'ON DELETE CASCADE '.
      'ON UPDATE CASCADE, '.
    'CONSTRAINT fk_data_has_dp_product_dp_id '.
      'FOREIGN KEY (dp_id) '.
      'REFERENCES dp_product (id) '.
      'ON DELETE CASCADE '.
      'ON UPDATE CASCADE '.
  ') ENGINE = InnoDB CHARSET=utf8'
);

$db->query( 'DROP TABLE IF EXISTS data_has_nhp_product' );

$db->query(
  'CREATE TABLE data_has_nhp_product ( '.
    'uid char(7) NOT NULL, '.
    'nhp_id int(11) NOT NULL, '.
    'type ENUM( "direct", "code", "word", "reverse-word", "simple", "no-vowel", "soundex" ), '.
    'PRIMARY KEY (uid, nhp_id), '.
    'INDEX fk_uid (uid), '.
    'INDEX fk_nhp_id (nhp_id), '.
    'INDEX dk_type (type), '.
    'CONSTRAINT fk_data_has_nhp_product_uid '.
      'FOREIGN KEY (uid) '.
      'REFERENCES data (uid) '.
      'ON DELETE CASCADE '.
      'ON UPDATE CASCADE, '.
    'CONSTRAINT fk_data_has_nhp_product_nhp_id '.
      'FOREIGN KEY (nhp_id) '.
      'REFERENCES nhp_product (id) '.
      'ON DELETE CASCADE '.
      'ON UPDATE CASCADE '.
  ') ENGINE = InnoDB CHARSET=utf8'
);

$db->query( 'DROP TABLE IF EXISTS drug_name' );

$db->query(
  'CREATE TABLE drug_name ( '.
    'PRIMARY KEY (name), '.
    'INDEX dk_dp_id (dp_id) '.
  ') SELECT brand_name AS name, id AS dp_id, COUNT(*) AS number_of_products '.
  'FROM dp_product '.
  'GROUP BY brand_name'
);

$db->query(
  'ALTER TABLE drug_name '.
  'ADD COLUMN also_natural_name TINYINT(1) NOT NULL DEFAULT 0, '.
  'ADD COLUMN name_simple VARCHAR(200) NULL DEFAULT NULL, '.
//  'ADD COLUMN name_no_vowel VARCHAR(200) NULL DEFAULT NULL, '.
//  'ADD COLUMN name_soundex VARCHAR(200) NULL DEFAULT NULL, '.
  'ADD INDEX dk_name_simple ( name_simple )'
//  'ADD INDEX dk_name_no_vowel ( name_no_vowel ), '.
//  'ADD INDEX dk_name_soundex ( name_soundex )'
);

// $db->query( 'UPDATE drug_name SET name_soundex = SOUNDEX( name )' );

$data = '';
$result = $db->query( 'SELECT name FROM drug_name' );
while( $row = $result->fetch_row() ) if( $row[0] ) {
  $data .= sprintf(
    '"%s","%s","%s"'."\n",
    $row[0],
    preg_replace( '/[^a-z0-9]/', '', strtolower( $row[0] ) ),
    preg_replace( '/[^bcdfghjklmnpqrstvwxz0-9]/', '', strtolower( $row[0] ) )
  );
}
$result->free();
file_put_contents( 'temp_drug_name.csv', $data );

$db->query(
  'CREATE TEMPORARY TABLE temp_drug_name ( '.
    'name CHAR(200) NOT NULL, '.
    'name_simple VARCHAR(127), '.
//    'name_no_vowel VARCHAR(127), '.
    'PRIMARY KEY (name), '.
    'INDEX dk_name_simple ( name_simple ) '.
//    'INDEX dk_name_no_vowel ( name_no_vowel ) '.
  ') ENGINE=InnoDB DEFAULT CHARSET=utf8'
);
$db->query(
  'LOAD DATA LOCAL INFILE "temp_drug_name.csv" '.
  'INTO TABLE temp_drug_name '.
  'FIELDS TERMINATED BY "," ENCLOSED BY \'"\' '.
  'LINES TERMINATED BY "\n";'
);
$result = $db->query(
  'UPDATE drug_name '.
  'JOIN temp_drug_name USING( name ) '.
  'SET drug_name.name_simple = temp_drug_name.name_simple'
//      'drug_name.name_no_vowel = temp_drug_name.name_no_vowel'
);

unlink( 'temp_drug_name.csv' );

///////////////////////////////////////////////////////////////////////////////////////////////////
print "Creating natural_name table\n";

$db->query( 'DROP TABLE IF EXISTS natural_name' );

$db->query(
  'CREATE TABLE natural_name ( '.
    'PRIMARY KEY (name), '.
    'INDEX dk_nhp_id (nhp_id) '.
  ') SELECT product_name AS name, id AS nhp_id, COUNT(*) AS number_of_products '.
  'FROM nhp_product '.
  'GROUP BY product_name'
);

// also need to include names from the nhp_name table
$db->query( 'DROP TABLE IF EXISTS natural_other_name' );

$db->query(
  'CREATE TABLE natural_other_name ( '.
    'PRIMARY KEY (name), '.
    'INDEX dk_nhp_id (nhp_id) '.
  ') SELECT name, nhp_id, COUNT(*) AS number_of_products '.
  'FROM nhp_name '.
  'LEFT JOIN natural_name USING( nhp_id, name ) '.
  'WHERE main = 0 '.
  'AND natural_name.nhp_id IS NULL '.
  'GROUP BY name'
);

$db->query(
  'REPLACE INTO natural_name '.
  'SELECT name, '.
         'IFNULL( natural_name.nhp_id, natural_other_name.nhp_id ), '.
         'IFNULL( natural_name.number_of_products, 0 ) + IFNULL( natural_other_name.number_of_products, 0 ) '.
  'FROM natural_name '.
  'LEFT OUTER JOIN natural_other_name USING( name ) '.
  'UNION ALL '.
  'SELECT name, '.
         'IFNULL( natural_name.nhp_id, natural_other_name.nhp_id ), '.
         'IFNULL( natural_name.number_of_products, 0 ) + IFNULL( natural_other_name.number_of_products, 0 ) '.
  'FROM natural_name '.
  'RIGHT OUTER JOIN natural_other_name USING( name )'
);

$db->query( 'DROP TABLE natural_other_name' );

$db->query(
  'ALTER TABLE natural_name '.
  'ADD COLUMN name_simple VARCHAR(200) NULL DEFAULT NULL, '.
//  'ADD COLUMN name_no_vowel VARCHAR(200) NULL DEFAULT NULL, '.
//  'ADD COLUMN name_soundex VARCHAR(200) NULL DEFAULT NULL, '.
  'ADD INDEX dk_name_simple ( name_simple )'
//  'ADD INDEX dk_name_no_vowel ( name_no_vowel ), '.
//  'ADD INDEX dk_name_soundex ( name_soundex )'
);

// $db->query( 'UPDATE natural_name SET name_soundex = SOUNDEX( name )' );

$data = '';
$result = $db->query( 'SELECT name FROM natural_name' );
while( $row = $result->fetch_row() ) if( $row[0] ) {
  $data .= sprintf(
    '"%s","%s","%s"'."\n",
    $row[0],
    preg_replace( '/[^a-z0-9]/', '', strtolower( $row[0] ) ),
    preg_replace( '/[^bcdfghjklmnpqrstvwxz0-9]/', '', strtolower( $row[0] ) )
  );
}
$result->free();
file_put_contents( 'temp_natural_name.csv', $data );

$db->query(
  'CREATE TEMPORARY TABLE temp_natural_name ( '.
    'name CHAR(200) NOT NULL, '.
    'name_simple VARCHAR(127), '.
//    'name_no_vowel VARCHAR(127), '.
    'PRIMARY KEY (name), '.
    'INDEX dk_name_simple ( name_simple ) '.
//    'INDEX dk_name_no_vowel ( name_no_vowel ) '.
  ') ENGINE=InnoDB DEFAULT CHARSET=utf8'
);
$db->query(
  'LOAD DATA LOCAL INFILE "temp_natural_name.csv" '.
  'INTO TABLE temp_natural_name '.
  'FIELDS TERMINATED BY "," ENCLOSED BY \'"\' '.
  'LINES TERMINATED BY "\n";'
);
$result = $db->query(
  'UPDATE natural_name '.
  'JOIN temp_natural_name USING( name ) '.
  'SET natural_name.name_simple = temp_natural_name.name_simple'
//      'natural_name.name_no_vowel = temp_natural_name.name_no_vowel'
);

unlink( 'temp_natural_name.csv' );

// mark which drugs match a natural product's name
$db->query(
  'UPDATE drug_name '.
  'JOIN natural_name USING( name ) '
  'SET drug_name.also_natural_name = 1'
);

///////////////////////////////////////////////////////////////////////////////////////////////////
print "Adding helper columns to data table\n";

$db->query(
  'ALTER TABLE data '.
  'ADD COLUMN id_name_sp_code VARCHAR(10) DEFAULT NULL, '.
  'ADD COLUMN id_name_sp_simple VARCHAR(127) DEFAULT NULL, '.
//  'ADD COLUMN id_name_sp_no_vowel VARCHAR(127) DEFAULT NULL, '.
//  'ADD COLUMN id_name_sp_soundex VARCHAR(127) DEFAULT NULL, '.
  'ADD COLUMN multiple TINYINT(1) DEFAULT NULL, '.
  'ADD INDEX dk_id_name_sp_code ( id_name_sp_code ), '.
  'ADD INDEX dk_id_name_sp_simple ( id_name_sp_simple )'
//  'ADD INDEX dk_id_name_sp_no_vowel ( id_name_sp_no_vowel ), '.
//  'ADD INDEX dk_id_name_sp_soundex ( id_name_sp_soundex )'
);

// $db->query( 'UPDATE data SET id_name_sp_soundex = SOUNDEX( id_name_sp )' );

$data = '';
$result = $db->query( 'SELECT uid, id_name_sp FROM data WHERE id_name_sp IS NOT NULL' );
while( $row = $result->fetch_row() ) if( $row[0] && $row[1] ) {
  $matches = array();
  preg_match( "/[0-9]{6,}/", $row[1], $matches );
  $data .= sprintf(
    '"%s",%s,"%s","%s"'."\n",
    $row[0],
    0 < count( $matches ) ? '"'.str_pad( $matches[0], 8, "0", STR_PAD_LEFT ).'"' : 'NULL',
    preg_replace( '/[^a-z0-9]/', '', strtolower( $row[1] ) ),
    preg_replace( '/[^bcdfghjklmnpqrstvwxz0-9]/', '', strtolower( $row[1] ) )
  );
}
$result->free();
file_put_contents( 'temp_data.csv', $data );

$db->query(
  'CREATE TEMPORARY TABLE temp_data ( '.
    'uid CHAR(7) NOT NULL, '.
    'id_name_sp_code VARCHAR(10), '.
    'id_name_sp_simple VARCHAR(127), '.
//    'id_name_sp_no_vowel VARCHAR(127), '.
    'PRIMARY KEY (uid), '.
    'INDEX dk_id_name_sp_code ( id_name_sp_code ), '.
    'INDEX dk_id_name_sp_simple ( id_name_sp_simple ) '.
//    'INDEX dk_id_name_sp_no_vowel ( id_name_sp_no_vowel ) '.
  ') ENGINE=InnoDB DEFAULT CHARSET=utf8'
);
$db->query(
  'LOAD DATA LOCAL INFILE "temp_data.csv" '.
  'INTO TABLE temp_data '.
  'FIELDS TERMINATED BY "," ENCLOSED BY \'"\' '.
  'LINES TERMINATED BY "\n"'
);
$result = $db->query(
  'UPDATE data '.
  'JOIN temp_data USING( uid ) '.
  'SET data.id_name_sp_code = temp_data.id_name_sp_code, '.
      'data.id_name_sp_simple = temp_data.id_name_sp_simple'
//      'data.id_name_sp_no_vowel = temp_data.id_name_sp_no_vowel'
);

unlink( 'temp_data.csv' );
