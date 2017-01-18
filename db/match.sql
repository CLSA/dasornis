UPDATE data SET match_type = NULL, multiple_matches = NULL, dp_id = NULL;


-- ------------------------------------------------------------------------------------------------
SELECT "Testing for direct drug matches" AS "";

SELECT "... with a single DIN" AS "";
UPDATE data
JOIN brand_name ON id_name_sp = brand_name.name
SET data.dp_id = brand_name.dp_id,
    data.match_type = "direct",
    data.multiple_matches = false
WHERE brand_name.number_of_products = 1;

SELECT "... with multiple DINs" AS "";
UPDATE data
JOIN brand_name ON id_name_sp = brand_name.name
SET data.dp_id = brand_name.dp_id,
    data.match_type = "direct",
    data.multiple_matches = true
WHERE data.dp_id IS NULL
AND brand_name.number_of_products > 1;


-- ------------------------------------------------------------------------------------------------
SELECT "Testing for direct drug matches" AS "";

SELECT "... with a single DIN" AS "";
UPDATE data
JOIN brand_name ON id_name_sp = brand_name.name
SET data.dp_id = brand_name.dp_id,
    data.match_type = "direct",
    data.multiple_matches = false
WHERE brand_name.number_of_products = 1;

SELECT "... with multiple DINs" AS "";
UPDATE data
JOIN brand_name ON id_name_sp = brand_name.name
SET data.dp_id = brand_name.dp_id,
    data.match_type = "direct",
    data.multiple_matches = true
WHERE data.dp_id IS NULL
AND brand_name.number_of_products > 1;


-- ------------------------------------------------------------------------------------------------
SELECT "Testing for simplified drug matches" AS "";

SELECT "... with a single DIN" AS "";
UPDATE data
JOIN brand_name ON data.id_name_sp_simple = brand_name.name_simple
SET data.dp_id = brand_name.dp_id,
    data.match_type = "simple",
    data.multiple_matches = false
WHERE data.dp_id IS NULL
AND brand_name.number_of_products = 1;

SELECT "... with multiple DINs" AS "";
UPDATE data
JOIN brand_name ON data.id_name_sp_simple = brand_name.name_simple
SET data.dp_id = brand_name.dp_id,
    data.match_type = "simple",
    data.multiple_matches = true
WHERE data.dp_id IS NULL
AND brand_name.number_of_products > 1;


-- ------------------------------------------------------------------------------------------------
SELECT "Testing for no-vowel drug matches" AS "";

SELECT "... with a single DIN" AS "";
UPDATE data
JOIN brand_name ON data.id_name_sp_no_vowel = brand_name.name_no_vowel
SET data.dp_id = brand_name.dp_id,
    data.match_type = "no_vowel",
    data.multiple_matches = false
WHERE data.dp_id IS NULL
AND brand_name.number_of_products = 1;

SELECT "... with multiple DINs" AS "";
UPDATE data
JOIN brand_name ON data.id_name_sp_no_vowel = brand_name.name_no_vowel
SET data.dp_id = brand_name.dp_id,
    data.match_type = "no_vowel",
    data.multiple_matches = true
WHERE data.dp_id IS NULL
AND brand_name.number_of_products > 1;


-- ------------------------------------------------------------------------------------------------
SELECT "Testing for soundex drug matches" AS "";

SELECT "... with a single DIN" AS "";
UPDATE data
JOIN brand_name ON data.id_name_sp_soundex = brand_name.name_soundex
SET data.dp_id = brand_name.dp_id,
    data.match_type = "soundex",
    data.multiple_matches = false
WHERE data.dp_id IS NULL
AND brand_name.number_of_products = 1;

SELECT "... with multiple DINs" AS "";
UPDATE data
JOIN brand_name ON data.id_name_sp_soundex = brand_name.name_soundex
SET data.dp_id = brand_name.dp_id,
    data.match_type = "soundex",
    data.multiple_matches = true
WHERE data.dp_id IS NULL
AND brand_name.number_of_products > 1;
