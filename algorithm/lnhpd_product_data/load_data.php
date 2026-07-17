<?php
/**
 * Script used to read natural health products from canada.ca
 * 
 * Running the script with no arguments will delete all existing natural products and reload them all
 * from the website's web API.
 * 
 * If the process breaks part way through, you can pick up from any page by providing the page as an
 * argument to the script.  So long as you start on a page > 1 the existing data will not be overwritten.
 * 
 * @author: Patrick D. Emond <emondpd@mcmaster.ca>
 */

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

define( 'START_PAGE', 1 < $argc ? $argv[1] : 1 );

printf( "Connecting to database\n" );
$db = new \mysqli( DB_SERV, DB_USER, DB_PASS, DB_NAME );

// do not rebuild tables and reload product data if we're not starting on page 1
if( 1 == START_PAGE )
{
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
      INDEX dk_npn (npn),
      UNIQUE KEY uq_lnhpd_id_npn_product_name_company_name (lnhpd_id, npn, product_name, company_name)
    ) ENGINE=InnoDB CHARSET=utf8
  SQL );

  $db->query( <<<SQL
    CREATE TABLE lnhpd_ingredient (
      lnhpd_id INT(11),
      name VARCHAR(200),
      KEY fk_lnhpd_id (lnhpd_id),
      UNIQUE KEY uq_lnhpd_id_name (lnhpd_id, name)
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
  $success_count = 0;
  $duplicate_count = 0;
  $skip_count = 0;
  foreach( $product_list as $product )
  {
    if( $product->licence_number )
    {
      $db->query( sprintf(
        'INSERT IGNORE INTO lnhpd_product VALUES (%d, "%s", "%s", "%s")',
        $product->lnhpd_id,
        $db->real_escape_string( $product->licence_number ),
        $db->real_escape_string( $product->product_name ),
        $db->real_escape_string( $product->company_name )
      ) );
      if( 0 == $db->affected_rows ) $duplicate_count++;
      else $success_count++;
    }
    else
    {
      $skip_count++;
    }
  }
  printf(
    " - %d records added, %d duplicates, %d skipped\n",
    $success_count,
    $duplicate_count,
    $skip_count
  );
}
else
{
  printf( "\nProduct Licence Data\n - skipping\n" );
}

printf( "\nMedicinal Ingredient Data\n - reading from LNHPD API (page by page)\n" );

$page = START_PAGE;
$iteration_first_page = $page;
$url = sprintf( '%s?page=%d&lang=en&type=json', INGREDIENT_URL, $page );
$success_count = 0;
$duplicate_count = 0;
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
        'INSERT IGNORE INTO lnhpd_ingredient VALUES (%d, "%s")',
        $ingredient->lnhpd_id,
        $db->real_escape_string( $ingredient->ingredient_name )
      ) );
      if( 0 == $db->affected_rows ) $duplicate_count++;
      else $success_count++;
    }
    catch( \mysqli_sql_exception $error )
    {
      $skip_count++;
    }
  }

  if (0 == $page % 100)
  {
    printf(
      " - loaded pages %d to %d of %d, (%d records added, %d duplicates, %d skipped)\n",
      $iteration_first_page,
      $page,
      ceil( $data->metadata->pagination->total / 100 ),
      $success_count,
      $duplicate_count,
      $skip_count
    );
    $success_count = 0;
    $duplicate_count = 0;
    $skip_count = 0;
    $iteration_first_page = $page + 1;
  }

  $page++;
  $url = $data->metadata->pagination->next;
} while ( !is_null( $url ) );

if( $page > $iteration_first_page )
{
  printf(
    " - loaded pages %d to %d of %d, (%d records added, %d duplicates, %d skipped)\n",
    $iteration_first_page,
    $page,
    ceil( $data->metadata->pagination->total / 100 ),
    $success_count,
    $duplicate_count,
    $skip_count
  );
}

printf( "\nDisconnecting from database\n" );
$db->close();
