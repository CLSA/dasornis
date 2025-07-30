<?php
ini_set( 'display_errors', '1' );
error_reporting( E_ALL );

define( 'BASE_URL', 'https://health-products.canada.ca/api/natural-licences' );
define( 'PRODUCT_URL', 'productlicence' );
define( 'DB_SERV', 'localhost' );
define( 'DB_USER', 'patrick' );
define( 'DB_PASS', '2h2Ros3ezXxt' );
define( 'DB_NAME', 'patrick_sandbox' );
ini_set( 'date.timezone', 'US/Eastern' );

printf( "Connecting to database\n" );
$db = new \mysqli( DB_SERV, DB_USER, DB_PASS, DB_NAME );

printf( " - rebuilding tables\n" );
$db->query( 'DROP TABLE IF EXISTS lnhpd_product' );

$db->query( <<<SQL
  CREATE TABLE lnhpd_product (
    lnhpd_id INT(11),
    npn CHAR(8),
    product_name VARCHAR(200),
    company_name VARCHAR(200),
    INDEX dk_lnhpd_id (lnhpd_id),
    UNIQUE INDEX dk_npn (npn)
  ) ENGINE=InnoDB CHARSET=utf8
SQL );

printf( "\nProduct Licence Data\n - reading from LNHPD API\n" );

$curl = curl_init();
curl_setopt( $curl, CURLOPT_URL, sprintf( '%s/%s?lang=en&type=json', BASE_URL, PRODUCT_URL ) );
curl_setopt( $curl, CURLOPT_RETURNTRANSFER, true );

$response = curl_exec( $curl );
if( curl_errno( $curl ) )
{
  printf( "Got error code %s when loading product database.\n%s\n", curl_errno( $curl ), curl_error( $curl ) );
  $db->close();
  die();
}

$code = curl_getinfo( $curl, CURLINFO_HTTP_CODE );
if( 200 != $code )
{
  printf( "Got response code %s when loading product database.\n", $code );
  $db->close();
  die();
}

printf( " - parsing JSON data\n" );
$product_list = json_decode( $response );
printf( " - %d records found\n", count( $product_list ) );

printf( " - loading data into database\n" );
foreach( $product_list as $product )
{
  // only import the entries that are marked as the primary name
  if( $product->flag_primary_name && $product->licence_number )
  {
    $db->query( sprintf(
      'INSERT IGNORE INTO lnhpd_product VALUES (%d, "%s", "%s", "%s")',
      $product->lnhpd_id,
      $db->real_escape_string( $product->licence_number ),
      $db->real_escape_string( $product->product_name ),
      $db->real_escape_string( $product->company_name )
    ) );
  }
}

printf( " - sanitizing names\n" );
$db->query( <<<'SQL'
  SET @re = "[^ a-zA-z0-9ÀàÁáÂâÃãÄäÇçÈèÉéÊêËëÌìÍíÎîÏïÑñÒòÓóÔôÕõÖöŠšÚùÛúÜûÙüÝýŸÿŽž\µ:<>«»²~!@#$%^&*()_+\\[\\]\\;',./{}|:\"<>?=-]"
SQL );

$db->query( <<<'SQL'
  UPDATE lnhpd_product SET
    product_name = regexp_replace( regexp_replace( regexp_replace( regexp_replace( replace(
      product_name,
      "ß", "B" ),
      "[°º]", "" ),
      "[·•]", " " ),
      @re, "" ),
      "  +", " "
    ),
    company_name = regexp_replace( regexp_replace( regexp_replace( regexp_replace( replace(
      company_name,
      "ß", "B"),
      "[°º]", "" ),
      "[·•]", " " ),
      @re, "" ),
      "  +", " "
    )
SQL );

printf( "\nDisconnecting from database\n" );
$db->close();
