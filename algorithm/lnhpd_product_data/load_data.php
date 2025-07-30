<?php
ini_set( 'display_errors', '1' );
error_reporting( E_ALL );

define( 'BASE_URL', 'https://health-products.canada.ca/api/natural-licences' );
define( 'PRODUCT_URL', 'productlicence' );
define( 'INGREDIENT_URL', 'medicinalingredient' );
define( 'DB_SERV', 'localhost' );
define( 'DB_USER', 'patrick' );
define( 'DB_PASS', '2h2Ros3ezXxt' );
define( 'DB_NAME', 'patrick_dasornis' );
ini_set( 'date.timezone', 'US/Eastern' );

printf( "Connecting to database\n" );
$db = new \mysqli( DB_SERV, DB_USER, DB_PASS, DB_NAME );

printf( " - rebuilding tables\n" );
$db->query( 'DROP TABLE IF EXISTS lnhpd_ingredient' );
$db->query( 'DROP TABLE IF EXISTS lnhpd_product' );

$db->query( <<<SQL
  CREATE TABLE lnhpd_product (
    lnhpd_id INT(11),
    npn CHAR(8),
    product_name VARCHAR(200),
    company_name VARCHAR(200),
    INDEX dk_lnhpd_id (lnhpd_id),
    INDEX dk_npn (npn)
  ) ENGINE=InnoDB CHARSET=utf8
SQL );

$db->query( <<<SQL
  CREATE TABLE lnhpd_ingredient (
    lnhpd_id INT(11),
    name VARCHAR(200),
    KEY fk_lnhpd_id (lnhpd_id),
    CONSTRAINT fk_lnhpd_ingredient_lnhpd_id
      FOREIGN KEY (lnhpd_id)
      REFERENCES lnhpd_product(lnhpd_id)
      ON DELETE CASCADE
      ON UPDATE CASCADE
  ) ENGINE=InnoDB CHARSET=utf8;
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
  $db->query( sprintf(
    'INSERT INTO lnhpd_product VALUES (%d, "%s", "%s", "%s")',
    $product->lnhpd_id,
    $db->real_escape_string( $product->licence_number ),
    $db->real_escape_string( $product->product_name ),
    $db->real_escape_string( $product->company_name )
  ) );
}

printf( "\nMedicinal Ingredient Data\n - reading from LNHPD API (page by page)\n" );

$page = 1;
$url = sprintf( '%s?page=1&lang=en&type=json', INGREDIENT_URL );
$success_count = 0;
$skip_count = 0;
do {
  $curl = curl_init();
  curl_setopt( $curl, CURLOPT_URL, sprintf( '%s/%s', BASE_URL, $url ) );
  curl_setopt( $curl, CURLOPT_RETURNTRANSFER, true );

  $response = curl_exec( $curl );
  if( curl_errno( $curl ) )
  {
    printf( "Got error code %s when loading ingredient database.\n%s\n", curl_errno( $curl ), curl_error( $curl ) );
    $db->close();
    die();
  }

  $code = curl_getinfo( $curl, CURLINFO_HTTP_CODE );
  if( 200 != $code )
  {
    printf( "Got response code %s when loading ingredient database.\n", $code );
    $db->close();
    die();
  }

  $data = json_decode( $response );

  foreach( $data->data as $ingredient )
  {
    try
    {
      $db->query( sprintf(
        'INSERT INTO lnhpd_ingredient VALUES (%d, "%s")',
        $ingredient->lnhpd_id,
        $db->real_escape_string( $ingredient->ingredient_name )
      ) );
      $success_count++;
    }
    catch( \mysqli_sql_exception $error )
    {
      $skip_count++;
    }
  }

  if (0 == $page % 100) {
    printf(
      " - loaded pages %d to %d of %d, (%d records added, %d skipped)\n",
      $page - 99,
      $page,
      ceil( $data->metadata->pagination->total / 100 ),
      $success_count,
      $skip_count
    );
    $success_count = 0;
    $skip_count = 0;
  }

  $page++;
  $url = $data->metadata->pagination->next;
} while ( !is_null( $url ) );


printf( "\nDisconnecting from database\n" );
$db->close();
