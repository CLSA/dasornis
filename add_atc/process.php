<?php
ini_set( 'display_errors', '1' );
error_reporting( E_ALL );

define( 'DB_SERV', 'localhost' );
define( 'DB_USER', 'patrick' );
define( 'DB_PASS', '2h2Ros3ezXxt' );
define( 'DB_NAME', 'patrick_dasornis' );
ini_set( 'date.timezone', 'US/Eastern' );
$db = new \mysqli( DB_SERV, DB_USER, DB_PASS, DB_NAME );

foreach( explode( "\n", file_get_contents( $argv[1] ) ) as $code )
{
  if( 0 == strlen( $code ) )
  {
    print( '"",""'."\n" );
  }
  else
  {
    $anumber = '';
    $atc = '';
    $response = $db->query( sprintf( 'SELECT id FROM dp_product WHERE din = %d', $code ) );
    $row = $response->fetch_array();
    if( !is_null( $row ) )
    {
      $response = $db->query( <<< SQL
        SELECT
          GROUP_CONCAT( DISTINCT anumber ORDER BY anumber SEPARATOR ";" ) AS anumber,
          GROUP_CONCAT( DISTINCT atc ORDER BY anumber SEPARATOR ";" ) AS atc
        FROM dp_therapeutic_class
        WHERE dp_id = {$row['id']}
      SQL );
      $row = $response->fetch_array();
      if( !is_null( $row ) )
      {
        $anumber = $row['anumber'];
        $atc = $row['atc'];
      }
    }

    printf( '"%d","%s","%s"'."\n", $code, $anumber, $atc );
  }
}
