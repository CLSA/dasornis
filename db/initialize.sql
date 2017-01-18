SELECT "Creating brand_name table" AS "";

DROP TABLE IF EXISTS brand_name;
CREATE TABLE brand_name (
  PRIMARY KEY (name),
  INDEX dk_drug_code (drug_code)
) SELECT brand_name AS name, drug_code, COUNT(*) AS number_of_drugs
FROM drug_product
GROUP BY brand_name;

ALTER TABLE brand_name
ADD COLUMN name_simple VARCHAR(200) NULL DEFAULT NULL,
ADD COLUMN name_soundex VARCHAR(200) NULL DEFAULT NULL,
ADD INDEX dk_name_simple ( name_simple ),
ADD INDEX dk_name_soundex ( name_soundex );
UPDATE brand_name
SET name_soundex = SOUNDEX( name );

SELECT "Adding helper columns to data table" AS "";

ALTER TABLE data
ADD COLUMN id_name_sp_simple VARCHAR(127) DEFAULT NULL,
ADD COLUMN id_name_sp_soundex VARCHAR(127) DEFAULT NULL,
ADD COLUMN match_type ENUM( "direct", "simple", "soundex" ),
ADD COLUMN multiple_matches TINYINT(1) DEFAULT NULL,
ADD COLUMN drug_code INT(11) DEFAULT NULL,
ADD INDEX dk_id_name_sp_simple ( id_name_sp_simple ),
ADD INDEX dk_id_name_sp_soundex ( id_name_sp_soundex ),
ADD INDEX fk_drug_code ( drug_code ),
ADD CONSTRAINT fk_data_drug_code
  FOREIGN KEY (drug_code) REFERENCES drug_product (drug_code)
  ON DELETE CASCADE ON UPDATE CASCADE;

UPDATE data SET id_name_sp_soundex = SOUNDEX( id_name_sp ); 
