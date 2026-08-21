<?php
ini_set( 'display_errors', '1' );
error_reporting( E_ALL );

define( 'DB_SERV', 'localhost' );
define( 'DB_USER', 'patrick' );
define( 'DB_PASS', '2h2Ros3ezXxt' );
define( 'DB_NAME', 'patrick_dasornis' );
ini_set( 'date.timezone', 'US/Eastern' );
$db = new \mysqli( DB_SERV, DB_USER, DB_PASS, DB_NAME );

foreach( explode( "\n", file_get_contents( $argv[1] ) ) as $line )
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
    $atc = '';

    if( 'DPD' == $type )
    {
      $response = $db->query( <<<SQL
        SELECT
          brand_name AS name,
          GROUP_CONCAT( DISTINCT anumber ORDER BY anumber SEPARATOR ";" ) atc
        FROM dp_product
        JOIN dp_therapeutic_class ON dp_product.id = dp_therapeutic_class.dp_id
        WHERE din = $code
        GROUP BY dp_product.id
        ORDER BY din
      SQL );
    }
    else
    {
      $response = $db->query( <<<SQL
        SELECT product_name AS name, "" AS atc
        FROM lnhpd_product
        WHERE npn = $code
      SQL );
    }

    $row = $response->fetch_array();
    if( !is_null( $row ) )
    {
      $name = $row['name'];
      $atc = $row['atc'];
    }

    printf( '"%d","%s","%s","%s"'."\n", $code, $type, $name, $atc );
  }
}
