SELECT "Creating risk table" AS "";

DROP TABLE IF EXISTS nhp_risk;
CREATE TABLE nhp_risk (
  nhp_id INT(11),
  risk_type_desc VARCHAR(120),
  risk_type_desc_french VARCHAR(120),
  sub_risk_type_desc VARCHAR(120),
  sub_risk_type_desc_french VARCHAR(120),
  risk_text_e VARCHAR(4000),
  risk_text_french VARCHAR(4000),
  KEY fk_nhp_id (nhp_id),
  CONSTRAINT fk_nhp_risk_nhp_id FOREIGN KEY (nhp_id)
  REFERENCES nhp_product(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB CHARSET=utf8;

LOAD DATA LOCAL INFILE "enc_NHP_PRODUCTS_RISK.txt"
INTO TABLE nhp_risk CHARACTER SET UTF8
FIELDS TERMINATED BY "|"
LINES TERMINATED BY "\r\n"
( @col_0, @col_1, @col_2, @col_3, @col_4, @col_5, @col_6 )
SET nhp_id = @col_0,
    risk_type_desc = NULLIF( @col_1, "" ),
    risk_type_desc_french = NULLIF( @col_2, "" ),
    sub_risk_type_desc = NULLIF( @col_3, "" ),
    sub_risk_type_desc_french = NULLIF( @col_4, "" ),
    risk_text_e = NULLIF( @col_5, "" ),
    risk_text_french = NULLIF( @col_6, "" );
