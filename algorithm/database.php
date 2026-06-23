<?php
/**
 * Manages common elements used in all database scripts
 */

require_once( 'settings.php' );

class db {
  function __construct() {
    $this->db = \mysqli_init();
    $this->db->options( MYSQLI_OPT_LOCAL_INFILE, true );
    $this->db->real_connect( SERVER, USERNAME, PASSWORD, NAME );
  }

  function __destruct() {
    $this->db->close();
  }

  function query( $sql ) {
    $result = $this->db->query( $sql );
    if( false === $result ) {
      printf( "mariadb > %s [%s] for query:\n%s\n", $this->db->error, $this->db->errno, $sql );

      die();
    }
    return $result;
  }
}

$db = new db();
