SELECT "Creating company table" AS "";

CREATE TABLE dp_company (
  dp_id INT NOT NULL,
  mfr_code VARCHAR(5),
  company_code INT,
  company_name VARCHAR(80),
  company_type VARCHAR(40),
  address_mailing_flag TINYINT(1),
  address_billing_flag TINYINT(1),
  address_notification_flag TINYINT(1),
  address_other TINYINT(1),
  suite_number VARCHAR(20),
  street_name VARCHAR(80),
  city_name VARCHAR(60),
  province VARCHAR(40),
  country VARCHAR(40),
  postal_code VARCHAR(20),
  post_office_box VARCHAR(15),
  KEY fk_dp_id (dp_id),
  KEY dk_company_name ( company_name ),
  CONSTRAINT fk_dp_company_dp_id FOREIGN KEY (dp_id)
  REFERENCES dp_product(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB CHARSET=utf8;

LOAD DATA LOCAL INFILE "enc_comp.txt"
INTO TABLE dp_company CHARACTER SET UTF8
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\n"
( @col_0, @col_1, @col_2, @col_3, @col_4, @col_5, @col_6, @col_7, @col_8, @col_9, @col_a, @col_b, @col_c, @col_d, @col_e, @col_f )
SET dp_id = @col_0,
    mfr_code = NULLIF( @col_1, "" ),
    company_code = NULLIF( @col_2, "" ),
    company_name = NULLIF( @col_3, "" ),
    company_type = NULLIF( @col_4, "" ),
    address_mailing_flag = IF( ""=@col_5, NULL, IF( "Y"=@col_5, 1, 0 ) ),
    address_billing_flag = IF( ""=@col_6, NULL, IF( "Y"=@col_6, 1, 0 ) ),
    address_notification_flag = IF( ""=@col_7, NULL, IF( "Y"=@col_7, 1, 0 ) ),
    address_other = IF( ""=@col_8, NULL, IF( "Y"=@col_8, 1, 0 ) ),
    suite_number = NULLIF( @col_9, "" ),
    street_name = NULLIF( @col_a, "" ),
    city_name = NULLIF( @col_b, "" ),
    province = NULLIF( @col_c, "" ),
    country = NULLIF( @col_d, "" ),
    postal_code = NULLIF( @col_e, "" ),
    post_office_box = NULLIF( @col_f, "" );

LOAD DATA LOCAL INFILE "enc_comp_ap.txt"
INTO TABLE dp_company CHARACTER SET UTF8
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\n"
( @col_0, @col_1, @col_2, @col_3, @col_4, @col_5, @col_6, @col_7, @col_8, @col_9, @col_a, @col_b, @col_c, @col_d, @col_e, @col_f )
SET dp_id = @col_0,
    mfr_code = NULLIF( @col_1, "" ),
    company_code = NULLIF( @col_2, "" ),
    company_name = NULLIF( @col_3, "" ),
    company_type = NULLIF( @col_4, "" ),
    address_mailing_flag = IF( ""=@col_5, NULL, IF( "Y"=@col_5, 1, 0 ) ),
    address_billing_flag = IF( ""=@col_6, NULL, IF( "Y"=@col_6, 1, 0 ) ),
    address_notification_flag = IF( ""=@col_7, NULL, IF( "Y"=@col_7, 1, 0 ) ),
    address_other = IF( ""=@col_8, NULL, IF( "Y"=@col_8, 1, 0 ) ),
    suite_number = NULLIF( @col_9, "" ),
    street_name = NULLIF( @col_a, "" ),
    city_name = NULLIF( @col_b, "" ),
    province = NULLIF( @col_c, "" ),
    country = NULLIF( @col_d, "" ),
    postal_code = NULLIF( @col_e, "" ),
    post_office_box = NULLIF( @col_f, "" );

LOAD DATA LOCAL INFILE "enc_comp_ia.txt"
INTO TABLE dp_company CHARACTER SET UTF8
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\n"
( @col_0, @col_1, @col_2, @col_3, @col_4, @col_5, @col_6, @col_7, @col_8, @col_9, @col_a, @col_b, @col_c, @col_d, @col_e, @col_f )
SET dp_id = @col_0,
    mfr_code = NULLIF( @col_1, "" ),
    company_code = NULLIF( @col_2, "" ),
    company_name = NULLIF( @col_3, "" ),
    company_type = NULLIF( @col_4, "" ),
    address_mailing_flag = IF( ""=@col_5, NULL, IF( "Y"=@col_5, 1, 0 ) ),
    address_billing_flag = IF( ""=@col_6, NULL, IF( "Y"=@col_6, 1, 0 ) ),
    address_notification_flag = IF( ""=@col_7, NULL, IF( "Y"=@col_7, 1, 0 ) ),
    address_other = IF( ""=@col_8, NULL, IF( "Y"=@col_8, 1, 0 ) ),
    suite_number = NULLIF( @col_9, "" ),
    street_name = NULLIF( @col_a, "" ),
    city_name = NULLIF( @col_b, "" ),
    province = NULLIF( @col_c, "" ),
    country = NULLIF( @col_d, "" ),
    postal_code = NULLIF( @col_e, "" ),
    post_office_box = NULLIF( @col_f, "" );
