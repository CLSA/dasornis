<?php
ini_set( 'display_errors', '1' );
error_reporting( E_ALL );

define( 'DB_SERV', 'localhost' );
define( 'DB_USER', 'patrick' );
define( 'DB_PASS', '2h2Ros3ezXxt' );
define( 'DB_NAME', 'patrick_dasornis' );
ini_set( 'date.timezone', 'US/Eastern' );
$db = new \mysqli( DB_SERV, DB_USER, DB_PASS, DB_NAME );

foreach( explode( "\n", file_get_contents( 'input.csv' ) ) as $line )
{
  if( 0 == strlen( $line ) )
  {
    print( '"","",""'."\n" );
  }
  else
  {
    $array = explode( ',', $line );
    $code = $array[0];
    $type = $array[1];
    $name = '';

    $response = $db->query(
      sprintf(
        'DPD' == $type ?
          'SELECT brand_name AS name FROM dp_product WHERE din = %d' :
          'SELECT product_name AS name FROM nhp_product WHERE npn = %d'
        ,
        $code
      )
    );

    $row = $response->fetch_array();
    if( !is_null( $row ) ) $name = $row['name'];

    printf( '"%d","%s","%s"'."\n", $code, $type, $name );
  }
}
