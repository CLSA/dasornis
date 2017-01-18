<?php
/**
 * Fills in simplified string versions of data.id_name_sp and brand_name.name
 */

include 'database.php';

$db = mysqli_init();
$db->options( MYSQLI_OPT_LOCAL_INFILE, true );
$db->real_connect( SERVER, USERNAME, PASSWORD, NAME );

///////////////////////////////////////////////////////////////////////////////////////////////////
print "\nSimplifying data.id_name_sp\n";
$data = '';
$result = $db->query( 'SELECT uid, id_name_sp FROM data WHERE id_name_sp IS NOT NULL' );
while( $row = $result->fetch_row() ) if( $row[0] && $row[1] )
  $data .= sprintf( '"%s","%s"'."\n", $row[0], preg_replace( '/[^a-z0-9]/', '', strtolower( $row[1] ) ) );
$result->free();
file_put_contents( 'temp1.csv', $data );

$db->query(
  'CREATE TEMPORARY TABLE temp1 ( '.
    'uid CHAR(7) NOT NULL, '.
    'id_name_sp_simple VARCHAR(127), '.
    'PRIMARY KEY (uid), '.
    'INDEX dk_id_name_sp_simple ( id_name_sp_simple ) '.
  ') ENGINE=InnoDB DEFAULT CHARSET=utf8'
);
$db->query(
  'LOAD DATA LOCAL INFILE "temp1.csv" '.
  'INTO TABLE temp1 '.
  'FIELDS TERMINATED BY "," ENCLOSED BY \'"\' '.
  'LINES TERMINATED BY "\n"'
);
$result = $db->query(
  'UPDATE data '.
  'JOIN temp1 USING( uid ) '.
  'SET data.id_name_sp_simple = temp1.id_name_sp_simple'
);
if( false === $result ) printf( "mysql > %s\n", $db->error );
else printf( "mysql > affected %d rows\n", $db->affected_rows );

unlink( 'temp1.csv' );

///////////////////////////////////////////////////////////////////////////////////////////////////
print "\nSimplifying brand_name.name\n";
$data = '';
$result = $db->query( 'SELECT name FROM brand_name' );
while( $row = $result->fetch_row() ) if( $row[0] )
  $data .= sprintf( '"%s","%s"'."\n", $row[0], preg_replace( '/[^a-z0-9]/', '', strtolower( $row[0] ) ) );
$result->free();
file_put_contents( 'temp2.csv', $data );

$db->query(
  'CREATE TEMPORARY TABLE temp2 ( '.
    'name CHAR(200) NOT NULL, '.
    'name_simple VARCHAR(127), '.
    'PRIMARY KEY (name), '.
    'INDEX dk_name_simple ( name_simple ) '.
  ') ENGINE=InnoDB DEFAULT CHARSET=utf8'
);
$db->query(
  'LOAD DATA LOCAL INFILE "temp2.csv" '.
  'INTO TABLE temp2 '.
  'FIELDS TERMINATED BY "," ENCLOSED BY \'"\' '.
  'LINES TERMINATED BY "\n";'
);
$result = $db->query(
  'UPDATE brand_name '.
  'JOIN temp2 USING( name ) '.
  'SET brand_name.name_simple = temp2.name_simple'
);
if( false === $result ) printf( "mysql > %s\n", $db->error );
else printf( "mysql > affected %d rows\n", $db->affected_rows );

unlink( 'temp2.csv' );


$db->close();
