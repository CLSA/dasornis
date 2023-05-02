<?php
ini_set( 'display_errors', '1' );
error_reporting( E_ALL );

define( 'DB_SERV', 'localhost' );
define( 'DB_USER', 'patrick' );
define( 'DB_PASS', '2h2Ros3ezXxt' );
define( 'DB_NAME', 'patrick_dasornis' );
ini_set( 'date.timezone', 'US/Eastern' );
$db = new \mysqli( DB_SERV, DB_USER, DB_PASS, DB_NAME );

$response = $db->query(
  'SELECT din, '.
         'GROUP_CONCAT( DISTINCT anumber ORDER BY anumber SEPARATOR ";" ) atc, '.
         'GROUP_CONCAT( DISTINCT ahfs_number ORDER BY ahfs_number SEPARATOR ";" ) ahfs '.
  'FROM dp_product '.
  'JOIN dp_therapeutic_class ON dp_product.id = dp_therapeutic_class.dp_id '.
  'GROUP BY dp_product.id '.
  'ORDER BY din'
);

$lookup = array();
while( $row = $response->fetch_array() )
  $lookup[ $row['din'] ] = array( 'atc' => $row['atc'], 'ahfs' => $row['ahfs'] );

foreach( explode( "\n", file_get_contents( $argv[1] ) ) as $line_index => $line )
{
  foreach( explode( ',', $line ) as $item_index => $item )
  {
    if( 0 == $item_index )
    {
      print $item;
    }
    else
    {
      $string = preg_replace( '/^"?(.*?)"?$/', '$1', $item );
      if( 0 == $line_index )
      {
        preg_match( '/MEDI_ID_DIN_SP2_([0-9]+)_COM/', $string, $matches );
        $number = $matches[1];
        printf( ',%s,"ATC_%d","AHFS_%d"', $item, $number, $number );
      }
      else
      {
        if( ' ' == $string )
        {
          print ',"","",""';
        }
        else
        {
          $din = str_pad( $string, 8, '0', STR_PAD_LEFT );
          if( array_key_exists( $din, $lookup ) )
          {
            printf( ',%s,"%s","%s"', $item, $lookup[$din]['atc'], $lookup[$din]['ahfs'] );
          }
          else
          {
            printf( ',%s,"",""', $item );
          }
        }
      }
    }
  }

  print "\n";
}
