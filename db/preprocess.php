#!/usr/bin/php
<?php
require_once( 'database.php' );

///////////////////////////////////////////////////////////////////////////////////////////////////
print "Creating auxiliry tables\n";

$db->query( 'DROP TABLE IF EXISTS data_has_din' );

$db->query(
  'CREATE TABLE data_has_din ( '.
    'uid char(10) NOT NULL, '.
    'din varchar(8) NOT NULL, '.
    'type ENUM( "predefined", "direct", "code", "word", "reverse-word", "simple", "no-parens", "no-units", "no-vowel", "soundex" ), '.
    'source ENUM( "predefined", "code", "product", "ingredient" ) NOT NULL, '.
    'PRIMARY KEY (uid, din), '.
    'INDEX fk_uid (uid), '.
    'INDEX fk_din (din), '.
    'INDEX dk_type (type), '.
    'INDEX dk_source (source), '.
    'CONSTRAINT fk_data_has_din_uid '.
      'FOREIGN KEY (uid) '.
      'REFERENCES data (uid) '.
      'ON DELETE CASCADE '.
      'ON UPDATE CASCADE '.
  ') ENGINE = InnoDB CHARSET=utf8'
);

$db->query( 'DROP TABLE IF EXISTS data_has_npn' );

$db->query(
  'CREATE TABLE data_has_npn ( '.
    'uid char(10) NOT NULL, '.
    'npn varchar(8) NOT NULL, '.
    'type ENUM( "predefined", "direct", "code", "word", "reverse-word", "simple", "no-parens", "no-units", "no-vowel", "soundex" ), '.
    'source ENUM( "predefined", "code", "product", "proper", "common" ) NOT NULL, '.
    'PRIMARY KEY (uid, npn), '.
    'INDEX fk_uid (uid), '.
    'INDEX fk_npn (npn), '.
    'INDEX dk_type (type), '.
    'INDEX dk_source (source), '.
    'CONSTRAINT fk_data_has_npn_uid '.
      'FOREIGN KEY (uid) '.
      'REFERENCES data (uid) '.
      'ON DELETE CASCADE '.
      'ON UPDATE CASCADE '.
  ') ENGINE = InnoDB CHARSET=utf8'
);

///////////////////////////////////////////////////////////////////////////////////////////////////
print "Creating drug_name table\n";

$db->query( 'DROP TABLE IF EXISTS drug_name' );

$db->query(
  'CREATE TABLE drug_name ( '.
    'PRIMARY KEY (name), '.
    'INDEX dk_din (din) '.
  ') SELECT brand_name AS name, MIN( din ) AS din '.
  'FROM dp_product '.
  'WHERE brand_name IS NOT NULL '.
  'GROUP BY brand_name'
);

$db->query(
  'ALTER TABLE drug_name '.
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
print "Creating drug_ingredient_name table\n";

$db->query( 'DROP TABLE IF EXISTS drug_ingredient_name' );

$db->query(
  'CREATE TABLE drug_ingredient_name ( '.
    'PRIMARY KEY (name), '.
    'INDEX dk_din (din) '.
  ') SELECT ingredient AS name, MIN( din ) AS din '.
  'FROM dp_active_ingredient '.
  'JOIN dp_product ON dp_active_ingredient.dp_id = dp_product.id '.
  'GROUP BY ingredient'
);

$db->query(
  'ALTER TABLE drug_ingredient_name '.
  'ADD COLUMN name_simple VARCHAR(200) NULL DEFAULT NULL, '.
  'ADD COLUMN name_no_parens VARCHAR(200) NULL DEFAULT NULL, '.
  'ADD COLUMN name_no_units VARCHAR(200) NULL DEFAULT NULL, '.
  'ADD INDEX dk_name_simple ( name_simple ), '.
  'ADD INDEX dk_name_no_parens ( name_no_parens ), '.
  'ADD INDEX dk_name_no_units ( name_no_units )'
);

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

$db->query(
  'CREATE TEMPORARY TABLE temp_drug_ingredient_name ( '.
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
  'LOAD DATA LOCAL INFILE "temp_drug_ingredient_name.csv" '.
  'INTO TABLE temp_drug_ingredient_name '.
  'FIELDS TERMINATED BY "," ENCLOSED BY \'"\' '.
  'LINES TERMINATED BY "\n";'
);
$result = $db->query(
  'UPDATE drug_ingredient_name '.
  'JOIN temp_drug_ingredient_name USING( name ) '.
  'SET drug_ingredient_name.name_simple = temp_drug_ingredient_name.name_simple,'.
  '    drug_ingredient_name.name_no_parens = temp_drug_ingredient_name.name_no_parens,'.
  '    drug_ingredient_name.name_no_units = temp_drug_ingredient_name.name_no_units'
);

unlink( 'temp_drug_ingredient_name.csv' );

///////////////////////////////////////////////////////////////////////////////////////////////////
print "Creating natural_name table\n";

$db->query( 'DROP TABLE IF EXISTS natural_name' );

$db->query(
  'CREATE TABLE natural_name ( '.
    'PRIMARY KEY (name), '.
    'INDEX dk_npn (npn) '.
  ') SELECT product_name AS name, MIN( npn ) AS npn '.
  'FROM nhp_product '.
  'WHERE product_name IS NOT NULL '.
  'GROUP BY product_name'
);

// also need to include names from the nhp_name table
$db->query( 'DROP TABLE IF EXISTS natural_other_name' );

$db->query(
  'CREATE TABLE natural_other_name ( '.
    'PRIMARY KEY (name), '.
    'INDEX dk_npn (npn) '.
  ') SELECT name, MIN( npn ) AS npn '.
  'FROM nhp_name '.
  'JOIN nhp_product ON nhp_name.nhp_id = nhp_product.id '.
  'LEFT JOIN natural_name USING( npn, name ) '.
  'WHERE main = 0 '.
  'AND natural_name.npn IS NULL '.
  'GROUP BY name'
);

$db->query(
  'REPLACE INTO natural_name '.
  'SELECT name, '.
         'IFNULL( natural_name.npn, natural_other_name.npn ) '.
  'FROM natural_name '.
  'LEFT OUTER JOIN natural_other_name USING( name ) '.
  'UNION ALL '.
  'SELECT name, '.
         'IFNULL( natural_name.npn, natural_other_name.npn ) '.
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

///////////////////////////////////////////////////////////////////////////////////////////////////
print "Creating natural_proper_name table\n";

$db->query( 'DROP TABLE IF EXISTS natural_proper_name' );

$db->query(
  'CREATE TABLE natural_proper_name ( '.
    'PRIMARY KEY (name), '.
    'INDEX dk_npn (npn) '.
  ') SELECT proper_name AS name, MIN( npn ) AS npn '.
  'FROM nhp_medicinal_ingredient '.
  'JOIN nhp_product ON nhp_medicinal_ingredient.nhp_id = nhp_product.id '.
  'GROUP BY proper_name'
);

$db->query(
  'ALTER TABLE natural_proper_name '.
  'ADD COLUMN name_simple VARCHAR(200) NULL DEFAULT NULL, '.
  'ADD COLUMN name_no_parens VARCHAR(200) NULL DEFAULT NULL, '.
  'ADD COLUMN name_no_units VARCHAR(200) NULL DEFAULT NULL, '.
  'ADD INDEX dk_name_simple ( name_simple ), '.
  'ADD INDEX dk_name_no_parens ( name_no_parens ), '.
  'ADD INDEX dk_name_no_units ( name_no_units )'
);

$data = '';
$result = $db->query( 'SELECT name FROM natural_proper_name' );
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
file_put_contents( 'temp_natural_proper_name.csv', $data );

$db->query(
  'CREATE TEMPORARY TABLE temp_natural_proper_name ( '.
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
  'LOAD DATA LOCAL INFILE "temp_natural_proper_name.csv" '.
  'INTO TABLE temp_natural_proper_name '.
  'FIELDS TERMINATED BY "," ENCLOSED BY \'"\' '.
  'LINES TERMINATED BY "\n";'
);
$result = $db->query(
  'UPDATE natural_proper_name '.
  'JOIN temp_natural_proper_name USING( name ) '.
  'SET natural_proper_name.name_simple = temp_natural_proper_name.name_simple,'.
  '    natural_proper_name.name_no_parens = temp_natural_proper_name.name_no_parens,'.
  '    natural_proper_name.name_no_units = temp_natural_proper_name.name_no_units'
);

unlink( 'temp_natural_proper_name.csv' );

///////////////////////////////////////////////////////////////////////////////////////////////////
print "Creating natural_common_name table\n";

$db->query( 'DROP TABLE IF EXISTS natural_common_name' );

$db->query(
  'CREATE TABLE natural_common_name ( '.
    'PRIMARY KEY (name), '.
    'INDEX dk_npn (npn) '.
  ') SELECT common_name AS name, MIN( npn ) AS npn '.
  'FROM nhp_medicinal_ingredient '.
  'JOIN nhp_product ON nhp_medicinal_ingredient.nhp_id = nhp_product.id '.
  'GROUP BY common_name'
);

$db->query(
  'ALTER TABLE natural_common_name '.
  'ADD COLUMN name_simple VARCHAR(200) NULL DEFAULT NULL, '.
  'ADD COLUMN name_no_parens VARCHAR(200) NULL DEFAULT NULL, '.
  'ADD COLUMN name_no_units VARCHAR(200) NULL DEFAULT NULL, '.
  'ADD INDEX dk_name_simple ( name_simple ), '.
  'ADD INDEX dk_name_no_parens ( name_no_parens ), '.
  'ADD INDEX dk_name_no_units ( name_no_units )'
);

$data = '';
$result = $db->query( 'SELECT name FROM natural_common_name' );
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
file_put_contents( 'temp_natural_common_name.csv', $data );

$db->query(
  'CREATE TEMPORARY TABLE temp_natural_common_name ( '.
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
  'LOAD DATA LOCAL INFILE "temp_natural_common_name.csv" '.
  'INTO TABLE temp_natural_common_name '.
  'FIELDS TERMINATED BY "," ENCLOSED BY \'"\' '.
  'LINES TERMINATED BY "\n";'
);
$result = $db->query(
  'UPDATE natural_common_name '.
  'JOIN temp_natural_common_name USING( name ) '.
  'SET natural_common_name.name_simple = temp_natural_common_name.name_simple,'.
  '    natural_common_name.name_no_parens = temp_natural_common_name.name_no_parens,'.
  '    natural_common_name.name_no_units = temp_natural_common_name.name_no_units'
);

unlink( 'temp_natural_common_name.csv' );

///////////////////////////////////////////////////////////////////////////////////////////////////
print "Adding helper columns to data table\n";

$result = $db->query(
  'SELECT column_name '.
  'FROM information_schema.columns '.
  'WHERE table_schema = DATABASE() '.
  'AND table_name = "data" '.
  'AND column_name IN ( "match_found", "id_name_sp_code", "id_name_sp_corrected", "id_name_sp_simple", "id_name_sp_no_parens", "id_name_sp_no_units" )'
);

while( $row = $result->fetch_row() ) {
  $db->query( sprintf( 'ALTER TABLE data DROP INDEX dk_%s', $row[0] ) );
  $db->query( sprintf( 'ALTER TABLE data DROP COLUMN %s', $row[0] ) );
}

$db->query(
  'ALTER TABLE data '.
  'ADD COLUMN match_found TINYINT(1) NOT NULL DEFAULT 0, '.
  'ADD COLUMN id_name_sp_code VARCHAR(10) DEFAULT NULL, '.
  'ADD COLUMN id_name_sp_corrected VARCHAR(127) DEFAULT NULL, '.
  'ADD COLUMN id_name_sp_simple VARCHAR(127) DEFAULT NULL, '.
  'ADD COLUMN id_name_sp_no_parens VARCHAR(127) DEFAULT NULL, '.
  'ADD COLUMN id_name_sp_no_units VARCHAR(127) DEFAULT NULL, '.
  'ADD INDEX dk_match_found ( match_found ), '.
  'ADD INDEX dk_id_name_sp_code ( id_name_sp_code ), '.
  'ADD INDEX dk_id_name_sp_corrected ( id_name_sp_corrected ), '.
  'ADD INDEX dk_id_name_sp_simple ( id_name_sp_simple ), '.
  'ADD INDEX dk_id_name_sp_no_parens ( id_name_sp_no_parens ), '.
  'ADD INDEX dk_id_name_sp_no_units ( id_name_sp_no_units )'
);

$data = '';
$result = $db->query(
  'SELECT uid, IFNULL( REPLACE( LOWER( id_name_sp ), input, output ), LOWER( id_name_sp ) ), id_din_sp '.
  'FROM data '.
  'LEFT JOIN lookup ON LOWER( id_name_sp ) RLIKE CONCAT( "[[:<:]]", LOWER( input ), "[[:>:]]" ) '.
  'WHERE id_name_sp IS NOT NULL'
);
while( $row = $result->fetch_row() ) if( $row[0] && $row[1] ) {
  $code = $row[2];
  if( is_null( $code ) )
  {
    $matches = array();
    preg_match( "/[0-9]{6,}/", $row[1], $matches );
    if( 0 < count( $matches ) ) $code = str_pad( $matches[0], 8, "0", STR_PAD_LEFT );
  }
  $data .= sprintf(
    0 < count( $matches ) ?
      '"%s",%s,NULL,NULL,NULL,NULL'."\n" :
      '"%s",%s,"%s","%s","%s","%s"'."\n",
    $row[0],
    is_null( $code ) ? 'NULL' : '"'.$code.'"',
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
    'uid CHAR(10) NOT NULL, '.
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
