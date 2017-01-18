SELECT "Creating companies table" AS "";

DROP TABLE IF EXISTS companies;
CREATE TABLE companies (
  drug_code INT NOT NULL,
  mfr_code VARCHAR(5),
  company_code INT,
  company_name VARCHAR(80),
  company_type VARCHAR(40),
  address_mailing_flag VARCHAR(1),
  address_billing_flag VARCHAR(1),
  address_notification_flag VARCHAR(1),
  address_other VARCHAR(1),
  suite_number VARCHAR(20),
  street_name VARCHAR(80),
  city_name VARCHAR(60),
  province VARCHAR(40),
  country VARCHAR(40),
  postal_code VARCHAR(20),
  post_office_box VARCHAR(15),
  KEY fk_drug_code (drug_code),
  KEY dk_company_name ( company_name ),
  CONSTRAINT fk_companies_drug_code FOREIGN KEY (drug_code)
  REFERENCES drug_product(drug_code) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB CHARSET=utf8;

LOAD DATA LOCAL INFILE "comp.txt"
INTO TABLE companies
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
( @col_0, @col_1, @col_2, @col_3, @col_4, @col_5, @col_6, @col_7, @col_8, @col_9, @col_a, @col_b, @col_c, @col_d, @col_e, @col_f )
SET drug_code = @col_0,
    mfr_code = NULLIF( @col_1, "" ),
    company_code = NULLIF( @col_2, "" ),
    company_name = NULLIF( @col_3, "" ),
    company_type = NULLIF( @col_4, "" ),
    address_mailing_flag = NULLIF( @col_5, "" ),
    address_billing_flag = NULLIF( @col_6, "" ),
    address_notification_flag = NULLIF( @col_7, "" ),
    address_other = NULLIF( @col_8, "" ),
    suite_number = NULLIF( @col_9, "" ),
    street_name = NULLIF( @col_a, "" ),
    city_name = NULLIF( @col_b, "" ),
    province = NULLIF( @col_c, "" ),
    country = NULLIF( @col_d, "" ),
    postal_code = NULLIF( @col_e, "" ),
    post_office_box = NULLIF( @col_f, "" );

LOAD DATA LOCAL INFILE "comp_ap.txt"
INTO TABLE companies
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
( @col_0, @col_1, @col_2, @col_3, @col_4, @col_5, @col_6, @col_7, @col_8, @col_9, @col_a, @col_b, @col_c, @col_d, @col_e, @col_f )
SET drug_code = @col_0,
    mfr_code = NULLIF( @col_1, "" ),
    company_code = NULLIF( @col_2, "" ),
    company_name = NULLIF( @col_3, "" ),
    company_type = NULLIF( @col_4, "" ),
    address_mailing_flag = NULLIF( @col_5, "" ),
    address_billing_flag = NULLIF( @col_6, "" ),
    address_notification_flag = NULLIF( @col_7, "" ),
    address_other = NULLIF( @col_8, "" ),
    suite_number = NULLIF( @col_9, "" ),
    street_name = NULLIF( @col_a, "" ),
    city_name = NULLIF( @col_b, "" ),
    province = NULLIF( @col_c, "" ),
    country = NULLIF( @col_d, "" ),
    postal_code = NULLIF( @col_e, "" ),
    post_office_box = NULLIF( @col_f, "" );

LOAD DATA LOCAL INFILE "comp_ia.txt"
INTO TABLE companies
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
( @col_0, @col_1, @col_2, @col_3, @col_4, @col_5, @col_6, @col_7, @col_8, @col_9, @col_a, @col_b, @col_c, @col_d, @col_e, @col_f )
SET drug_code = @col_0,
    mfr_code = NULLIF( @col_1, "" ),
    company_code = NULLIF( @col_2, "" ),
    company_name = NULLIF( @col_3, "" ),
    company_type = NULLIF( @col_4, "" ),
    address_mailing_flag = NULLIF( @col_5, "" ),
    address_billing_flag = NULLIF( @col_6, "" ),
    address_notification_flag = NULLIF( @col_7, "" ),
    address_other = NULLIF( @col_8, "" ),
    suite_number = NULLIF( @col_9, "" ),
    street_name = NULLIF( @col_a, "" ),
    city_name = NULLIF( @col_b, "" ),
    province = NULLIF( @col_c, "" ),
    country = NULLIF( @col_d, "" ),
    postal_code = NULLIF( @col_e, "" ),
    post_office_box = NULLIF( @col_f, "" );
