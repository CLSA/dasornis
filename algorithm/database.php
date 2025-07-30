<?php
/**
 * Manages common elements used in all database scripts
 */

require_once( 'settings.php' );

class db {
  function __construct() {
    $this->mysql = mysqli_init();
    $this->mysql->options( MYSQLI_OPT_LOCAL_INFILE, true );
    $this->mysql->real_connect( SERVER, USERNAME, PASSWORD, NAME );
  }

  function __destruct() {
    $this->mysql->close();
  }

  function query( $sql ) {
    $result = $this->mysql->query( $sql );
    if( false === $result ) {
      printf( "mysql > %s [%s] for query:\n%s\n", $this->mysql->error, $this->mysql->errno, $sql );

      die();
    }
    return $result;
  }
}

$db = new db();
