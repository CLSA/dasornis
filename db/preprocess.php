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
    'type ENUM( "direct", "code", "word", "reverse-word", "simple", "no-parens", "no-units", "no-vowel", "soundex" ), '.
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
    'type ENUM( "direct", "code", "word", "reverse-word", "simple", "no-parens", "no-units", "no-vowel", "soundex" ), '.
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
  'ADD COLUMN name_no_parens VARCHAR(200) NULL DEFAULT NULL, '.
  'ADD COLUMN name_no_units VARCHAR(200) NULL DEFAULT NULL, '.
  'ADD INDEX dk_name_simple ( name_simple ), '.
  'ADD INDEX dk_name_no_parens ( name_no_parens ), '.
  'ADD INDEX dk_name_no_units ( name_no_units )'
);

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

$db->query(
  'CREATE TEMPORARY TABLE temp_drug_name ( '.
    'name CHAR(200) NOT NULL, '.
    'name_simple VARCHAR(127), '.
    'name_no_parens VARCHAR(127), '.
    'name_no_units VARCHAR(127), '.
    'PRIMARY KEY (name), '.
    'INDEX dk_name_simple ( name_simple ), '.
    'INDEX dk_name_no_parens ( name_no_parens ), '.
    'INDEX dk_name_no_units ( name_no_units ) '.
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
  'SET drug_name.name_simple = temp_drug_name.name_simple,'.
  '    drug_name.name_no_parens = temp_drug_name.name_no_parens,'.
  '    drug_name.name_no_units = temp_drug_name.name_no_units'
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
  'ADD COLUMN name_no_parens VARCHAR(200) NULL DEFAULT NULL, '.
  'ADD COLUMN name_no_units VARCHAR(200) NULL DEFAULT NULL, '.
  'ADD INDEX dk_name_simple ( name_simple ), '.
  'ADD INDEX dk_name_no_parens ( name_no_parens ), '.
  'ADD INDEX dk_name_no_units ( name_no_units )'
);

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

$db->query(
  'CREATE TEMPORARY TABLE temp_natural_name ( '.
    'name CHAR(200) NOT NULL, '.
    'name_simple VARCHAR(127), '.
    'name_no_parens VARCHAR(127), '.
    'name_no_units VARCHAR(127), '.
    'PRIMARY KEY (name), '.
    'INDEX dk_name_simple ( name_simple ), '.
    'INDEX dk_name_no_parens ( name_no_parens ), '.
    'INDEX dk_name_no_units ( name_no_units ) '.
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
  'SET natural_name.name_simple = temp_natural_name.name_simple,'.
  '    natural_name.name_no_parens = temp_natural_name.name_no_parens,'.
  '    natural_name.name_no_units = temp_natural_name.name_no_units'
);

unlink( 'temp_natural_name.csv' );

// mark which drugs match a natural product's name
$db->query(
  'UPDATE drug_name '.
  'JOIN natural_name USING( name ) '.
  'SET drug_name.also_natural_name = 1'
);

///////////////////////////////////////////////////////////////////////////////////////////////////
print "Adding helper columns to data table\n";

$result = $db->query(
  'SELECT column_name '.
  'FROM information_schema.columns '.
  'WHERE table_schema = DATABASE() '.
  'AND table_name = "data" '.
  'AND column_name IN ( "id_name_sp_code", "id_name_sp_corrected", "id_name_sp_simple", "id_name_sp_no_parens", "id_name_sp_no_units", "multiple" )'
);

while( $row = $result->fetch_row() ) {
  if( 'multiple' != $row[0] ) $db->query( sprintf( 'ALTER TABLE data DROP INDEX dk_%s', $row[0] ) );
  $db->query( sprintf( 'ALTER TABLE data DROP COLUMN %s', $row[0] ) );
}

$db->query(
  'ALTER TABLE data '.
  'ADD COLUMN id_name_sp_code VARCHAR(10) DEFAULT NULL, '.
  'ADD COLUMN id_name_sp_corrected VARCHAR(127) DEFAULT NULL, '.
  'ADD COLUMN id_name_sp_simple VARCHAR(127) DEFAULT NULL, '.
  'ADD COLUMN id_name_sp_no_parens VARCHAR(127) DEFAULT NULL, '.
  'ADD COLUMN id_name_sp_no_units VARCHAR(127) DEFAULT NULL, '.
  'ADD COLUMN multiple TINYINT(1) DEFAULT NULL, '.
  'ADD INDEX dk_id_name_sp_code ( id_name_sp_code ), '.
  'ADD INDEX dk_id_name_sp_corrected ( id_name_sp_corrected ), '.
  'ADD INDEX dk_id_name_sp_simple ( id_name_sp_simple ), '.
  'ADD INDEX dk_id_name_sp_no_parens ( id_name_sp_no_parens ), '.
  'ADD INDEX dk_id_name_sp_no_units ( id_name_sp_no_units )'
);

$data = '';
$result = $db->query(
  'SELECT uid, LOWER( IFNULL( lookup.output, id_name_sp ) ) '.
  'FROM data '.
  'LEFT JOIN lookup ON id_name_sp LIKE CONCAT( "%", input, "%" ) '.
  'WHERE id_name_sp IS NOT NULL'
);
while( $row = $result->fetch_row() ) if( $row[0] && $row[1] ) {
  $matches = array();
  preg_match( "/[0-9]{6,}/", $row[1], $matches );
  $data .= sprintf(
    '"%s",%s,"%s","%s","%s","%s"'."\n",
    $row[0],
    0 < count( $matches ) ? '"'.str_pad( $matches[0], 8, "0", STR_PAD_LEFT ).'"' : 'NULL',
    $row[1],
    preg_replace( '/[^a-z0-9]/', '', $row[1] ),
    preg_replace( '/ *\([^)]+\)/', '', $row[1] ),
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
      ) ), '', $row[1]
    ) )
  );
}
$result->free();
file_put_contents( 'temp_data.csv', $data );

$db->query(
  'CREATE TEMPORARY TABLE temp_data ( '.
    'uid CHAR(7) NOT NULL, '.
    'id_name_sp_code VARCHAR(10), '.
    'id_name_sp_corrected VARCHAR(127), '.
    'id_name_sp_simple VARCHAR(127), '.
    'id_name_sp_no_parens VARCHAR(127), '.
    'id_name_sp_no_units VARCHAR(127), '.
    'PRIMARY KEY (uid), '.
    'INDEX dk_id_name_sp_code ( id_name_sp_code ), '.
    'INDEX dk_id_name_sp_corrected ( id_name_sp_corrected ), '.
    'INDEX dk_id_name_sp_simple ( id_name_sp_simple ), '.
    'INDEX dk_id_name_sp_no_parens ( id_name_sp_no_parens ), '.
    'INDEX dk_id_name_sp_no_units ( id_name_sp_no_units ) '.
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
      'data.id_name_sp_corrected = temp_data.id_name_sp_corrected, '.
      'data.id_name_sp_simple = temp_data.id_name_sp_simple, '.
      'data.id_name_sp_no_parens = temp_data.id_name_sp_no_parens,'.
      'data.id_name_sp_no_units = temp_data.id_name_sp_no_units'
);

unlink( 'temp_data.csv' );
