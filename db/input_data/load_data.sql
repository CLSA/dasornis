SELECT "Creating data table" AS "";

DROP TABLE IF EXISTS data;
CREATE TABLE data (
  uid CHAR(7) NOT NULL,
  id ENUM( "DIN","MEDICATION-NAME" ) COMMENT "Opal variable: MEDI_ID_1_COM",
  id_din_sp CHAR(8) COMMENT "Opal variable: MEDI_ID_DIN_SP_1_COM",
  id_name_sp VARCHAR(127) COMMENT "Opal variable: MEDI_ID_NAME_SP_1_COM",
  pres VARCHAR(127) COMMENT "Opal Variable: MEDI_PRES_1_COM",
  dose_nb FLOAT COMMENT "Opal variable: MEDI_DOSE_NB_1_COM",
  dose_unit VARCHAR(127) COMMENT "Opal Variable: MEDI_DOSE_UNIT_",
  dose_frq VARCHAR(127) COMMENT "Opal Variable: MEDI_DOSE_FRQ_1_COM",
  dose_frq_otsp VARCHAR(1023) COMMENT "Opal variable: MEDI_DOSE_FRQ_OTSP_1_COM",
  dose_cmt VARCHAR(1023) COMMENT "Opal variable: MEDI_DOSE_CMT_1_COM",
  use2 VARCHAR(127) COMMENT "Opal Variable: MEDI_USE2_1_COM",
  start_sp DATE COMMENT "Opal variable: MEDI_START_SP_1_COM",
  reason_sp VARCHAR(1023) COMMENT "Opal variable: MEDI_REASON_SP_1_COM",
  PRIMARY KEY (uid),
  INDEX dk_id_din_sp ( id_din_sp ),
  INDEX dk_id_name_sp ( id_name_sp ),
  INDEX dk_pres ( pres ),
  INDEX dk_dose_nb ( dose_nb ),
  INDEX dk_dose_unit ( dose_unit ),
  INDEX dk_dose_frq ( dose_frq ),
  INDEX dk_use2 ( use2 ),
  INDEX dk_start_sp ( start_sp ),
  INDEX dk_reason_sp ( reason_sp )
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE "enc_data.csv"
INTO TABLE data
FIELDS TERMINATED BY "," ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
IGNORE 1 LINES
( @col_0, @col_1, @col_2, @col_3, @col_4, @col_5, @col_6, @col_7, @col_8, @col_9,
  @col_10, @col_11, @col_12, @col_13, @col_14, @col_15, @col_16, @col_17 )
SET uid = @col_0,
    id = IF( "" = @col_1, NULL, @col_1 ),
    id_din_sp = IF( "" = @col_2, NULL, @col_2 ),
    id_name_sp = IF( "" = @col_3, NULL, @col_3 ),
    pres = IF( "" = @col_4, NULL, @col_4 ),
    dose_nb = IF( "" = @col_5, NULL, CAST( @col_5 AS DECIMAL ) ),
    dose_unit = IF( "" = @col_6, NULL, @col_6 ),
    dose_frq = IF( "" = @col_7, NULL, @col_7 ),
    dose_frq_otsp = IF( "" = @col_8, NULL, @col_8 ),
    dose_cmt = IF( "" = @col_9, NULL, @col_9 ),
    use2 = IF( "" = @col_13, NULL, @col_13 ),
    start_sp = IF(
      "" = @col_15,
      NULL,
      IF(
        @col_15 RLIKE "[0-9]{4}-[0-9]{2}-[0-9]{2}",
        @col_15,
        STR_TO_DATE( @col_15, "%m/%d/%Y" )
      )
    ),
    reason_sp = IF( "" = @col_17, NULL, @col_17 );

DELETE FROM data WHERE id_din_sp IS NOT NULL;
