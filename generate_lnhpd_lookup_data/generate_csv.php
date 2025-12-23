<?php
ini_set( 'display_errors', '1' );
error_reporting( E_ALL );

define( 'DB_SERV', 'localhost' );
define( 'DB_USER', 'patrick' );
define( 'DB_PASS', '2h2Ros3ezXxt' );
define( 'DB_NAME', 'patrick_sandbox' );
ini_set( 'date.timezone', 'US/Eastern' );

$db = new \mysqli( DB_SERV, DB_USER, DB_PASS, DB_NAME );

$result = $db->query(
  'SELECT '.
    'npn AS identifier, '.
    'product_name AS name, '.
    'CONCAT( product_name, " (", company_name, ")" ) AS description '.
  'FROM lnhpd_product '.
  'ORDER BY npn'
);

$csv_filename = sprintf( 'lnhpd.%s.csv', date("Ymd") );
$zip_filename = sprintf( 'lnhpd.%s.zip', date("Ymd") );
$fp = fopen( $csv_filename, 'w' );

while( $row = $result->fetch_assoc() )
{
  fputcsv( $fp, [$row['identifier'], $row['name'], $row['description'], ''] );
}

fclose( $fp );

exec( sprintf( 'zip %s %s', $zip_filename, $csv_filename ) );
unlink( $csv_filename );
