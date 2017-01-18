UPDATE data SET match_type = NULL, multiple_matches = NULL, drug_code = NULL;


-- ------------------------------------------------------------------------------------------------
SELECT "Testing for direct matches" AS "";

SELECT "... with a single DIN" AS "";
UPDATE data
JOIN brand_name ON id_name_sp = brand_name.name
SET data.drug_code = brand_name.drug_code,
    data.match_type = "direct",
    data.multiple_matches = false
WHERE brand_name.number_of_drugs = 1;

SELECT "... with multiple DINs" AS "";
UPDATE data
JOIN brand_name ON id_name_sp = brand_name.name
SET data.drug_code = brand_name.drug_code,
    data.match_type = "direct",
    data.multiple_matches = true
WHERE data.drug_code IS NULL
AND brand_name.number_of_drugs > 1;


-- ------------------------------------------------------------------------------------------------
SELECT "Testing for simplified matches" AS "";

SELECT "... with a single DIN" AS "";
UPDATE data
JOIN brand_name ON data.id_name_sp_simple = brand_name.name_simple
SET data.drug_code = brand_name.drug_code,
    data.match_type = "simple",
    data.multiple_matches = false
WHERE data.drug_code IS NULL
AND brand_name.number_of_drugs = 1;

SELECT "... with multiple DINs" AS "";
UPDATE data
JOIN brand_name ON data.id_name_sp_simple = brand_name.name_simple
SET data.drug_code = brand_name.drug_code,
    data.match_type = "simple",
    data.multiple_matches = true
WHERE data.drug_code IS NULL
AND brand_name.number_of_drugs > 1;


-- ------------------------------------------------------------------------------------------------
SELECT "Testing for soundex matches" AS "";

SELECT "... with a single DIN" AS "";
UPDATE data
JOIN brand_name ON data.id_name_sp_soundex = brand_name.name_soundex
SET data.drug_code = brand_name.drug_code,
    data.match_type = "soundex",
    data.multiple_matches = false
WHERE data.drug_code IS NULL
AND brand_name.number_of_drugs = 1;

SELECT "... with multiple DINs" AS "";
UPDATE data
JOIN brand_name ON data.id_name_sp_soundex = brand_name.name_soundex
SET data.drug_code = brand_name.drug_code,
    data.match_type = "soundex",
    data.multiple_matches = true
WHERE data.drug_code IS NULL
AND brand_name.number_of_drugs > 1;
