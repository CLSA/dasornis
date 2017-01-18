#!/usr/bin/php
<?php
require_once( 'database.php' );

///////////////////////////////////////////////////////////////////////////////////////////////////
print "Creating drug_name table\n";

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
  'ADD COLUMN name_simple VARCHAR(200) NULL DEFAULT NULL, '.
  'ADD COLUMN name_no_vowel VARCHAR(200) NULL DEFAULT NULL, '.
  'ADD COLUMN name_soundex VARCHAR(200) NULL DEFAULT NULL, '.
  'ADD INDEX dk_name_simple ( name_simple ), '.
  'ADD INDEX dk_name_no_vowel ( name_no_vowel ), '.
  'ADD INDEX dk_name_soundex ( name_soundex )'
);

$db->query( 'UPDATE drug_name SET name_soundex = SOUNDEX( name )' );

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
    'name_no_vowel VARCHAR(127), '.
    'PRIMARY KEY (name), '.
    'INDEX dk_name_simple ( name_simple ), '.
    'INDEX dk_name_no_vowel ( name_no_vowel ) '.
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
  'SET drug_name.name_simple = temp_drug_name.name_simple, '.
      'drug_name.name_no_vowel = temp_drug_name.name_no_vowel'
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

/*
$db->query(
  'INSERT IGNORE INTO natural_name( name, nhp_id, number_of_products ) '.
  'SELECT name, nhp_id,  '.
  ' '.
  ' '.
  ' '.
);
*/

$db->query(
  'ALTER TABLE natural_name '.
  'ADD COLUMN name_simple VARCHAR(200) NULL DEFAULT NULL, '.
  'ADD COLUMN name_no_vowel VARCHAR(200) NULL DEFAULT NULL, '.
  'ADD COLUMN name_soundex VARCHAR(200) NULL DEFAULT NULL, '.
  'ADD INDEX dk_name_simple ( name_simple ), '.
  'ADD INDEX dk_name_no_vowel ( name_no_vowel ), '.
  'ADD INDEX dk_name_soundex ( name_soundex )'
);

$db->query( 'UPDATE natural_name SET name_soundex = SOUNDEX( name )' );

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
    'name_no_vowel VARCHAR(127), '.
    'PRIMARY KEY (name), '.
    'INDEX dk_name_simple ( name_simple ), '.
    'INDEX dk_name_no_vowel ( name_no_vowel ) '.
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
  'SET natural_name.name_simple = temp_natural_name.name_simple, '.
      'natural_name.name_no_vowel = temp_natural_name.name_no_vowel'
);

unlink( 'temp_natural_name.csv' );

///////////////////////////////////////////////////////////////////////////////////////////////////
print "Adding helper columns to data table\n";

$db->query(
  'ALTER TABLE data '.
  'ADD COLUMN id_name_sp_simple VARCHAR(127) DEFAULT NULL, '.
  'ADD COLUMN id_name_sp_no_vowel VARCHAR(127) DEFAULT NULL, '.
  'ADD COLUMN id_name_sp_soundex VARCHAR(127) DEFAULT NULL, '.
  'ADD COLUMN match_type ENUM( "direct", "simple", "no_vowel", "soundex" ), '.
  'ADD COLUMN multiple_matches TINYINT(1) DEFAULT NULL, '.
  'ADD COLUMN dp_id INT(11) DEFAULT NULL, '.
  'ADD INDEX dk_id_name_sp_simple ( id_name_sp_simple ), '.
  'ADD INDEX dk_id_name_sp_no_vowel ( id_name_sp_no_vowel ), '.
  'ADD INDEX dk_id_name_sp_soundex ( id_name_sp_soundex ), '.
  'ADD INDEX fk_dp_id ( dp_id ), '.
  'ADD CONSTRAINT fk_data_dp_id '.
    'FOREIGN KEY (dp_id) REFERENCES dp_product (id) '.
    'ON DELETE SET NULL ON UPDATE CASCADE'
);

$db->query( 'UPDATE data SET id_name_sp_soundex = SOUNDEX( id_name_sp )' );

$data = '';
$result = $db->query( 'SELECT uid, id_name_sp FROM data WHERE id_name_sp IS NOT NULL' );
while( $row = $result->fetch_row() ) if( $row[0] && $row[1] ) {
  $data .= sprintf(
    '"%s","%s","%s"'."\n",
    $row[0],
    preg_replace( '/[^a-z0-9]/', '', strtolower( $row[1] ) ),
    preg_replace( '/[^bcdfghjklmnpqrstvwxz0-9]/', '', strtolower( $row[1] ) )
  );
}
$result->free();
file_put_contents( 'temp_data.csv', $data );

$db->query(
  'CREATE TEMPORARY TABLE temp_data ( '.
    'uid CHAR(7) NOT NULL, '.
    'id_name_sp_simple VARCHAR(127), '.
    'id_name_sp_no_vowel VARCHAR(127), '.
    'PRIMARY KEY (uid), '.
    'INDEX dk_id_name_sp_simple ( id_name_sp_simple ), '.
    'INDEX dk_id_name_sp_no_vowel ( id_name_sp_no_vowel ) '.
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
  'SET data.id_name_sp_simple = temp_data.id_name_sp_simple, '.
      'data.id_name_sp_no_vowel = temp_data.id_name_sp_no_vowel'
);

unlink( 'temp_data.csv' );
