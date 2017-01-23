TRUNCATE data_has_dp_product;
TRUNCATE data_has_nhp_product;

-- ------------------------------------------------------------------------------------------------
SELECT "Testing for direct drug matches" AS "";

INSERT INTO data_has_dp_product( uid, dp_id, type )
SELECT DISTINCT uid, dp_id, "direct"
FROM data
JOIN drug_name ON id_name_sp = drug_name.name;


-- ------------------------------------------------------------------------------------------------
SELECT "Testing for direct natural matches" AS "";

INSERT INTO data_has_nhp_product( uid, nhp_id, type )
SELECT DISTINCT uid, nhp_id, "direct"
FROM data
JOIN natural_name ON id_name_sp = natural_name.name
WHERE uid NOT IN (
  SELECT DISTINCT uid FROM data_has_dp_product UNION SELECT DISTINCT uid FROM data_has_nhp_product
);


-- ------------------------------------------------------------------------------------------------
SELECT "Testing for DIN matches" AS "";

INSERT INTO data_has_dp_product( uid, dp_id, type )
SELECT DISTINCT uid, dp_product.id, "code"
FROM data
JOIN dp_product ON id_name_sp_code = dp_product.din
WHERE uid NOT IN (
  SELECT DISTINCT uid FROM data_has_dp_product UNION SELECT DISTINCT uid FROM data_has_nhp_product
);


-- ------------------------------------------------------------------------------------------------
SELECT "Testing for NPN matches" AS "";

INSERT INTO data_has_nhp_product( uid, nhp_id, type )
SELECT DISTINCT uid, nhp_product.id, "code"
FROM data
JOIN nhp_product ON id_name_sp_code = nhp_product.npn
WHERE uid NOT IN (
  SELECT DISTINCT uid FROM data_has_dp_product UNION SELECT DISTINCT uid FROM data_has_nhp_product
);


-- ------------------------------------------------------------------------------------------------
SELECT "Testing for simplified drug matches" AS "";

INSERT INTO data_has_dp_product( uid, dp_id, type )
SELECT DISTINCT uid, dp_id, "simple"
FROM data
JOIN drug_name ON data.id_name_sp_simple = drug_name.name_simple
WHERE uid NOT IN (
  SELECT DISTINCT uid FROM data_has_dp_product UNION SELECT DISTINCT uid FROM data_has_nhp_product
);


-- ------------------------------------------------------------------------------------------------
SELECT "Testing for simplified natural matches" AS "";

INSERT INTO data_has_nhp_product( uid, nhp_id, type )
SELECT DISTINCT uid, nhp_id, "simple"
FROM data
JOIN natural_name ON data.id_name_sp_simple = natural_name.name_simple
WHERE uid NOT IN (
  SELECT DISTINCT uid FROM data_has_dp_product UNION SELECT DISTINCT uid FROM data_has_nhp_product
);


-- ------------------------------------------------------------------------------------------------
SELECT "Testing for no-vowel drug matches" AS "";

INSERT INTO data_has_dp_product( uid, dp_id, type )
SELECT DISTINCT uid, dp_id, "no_vowel"
FROM data
JOIN drug_name ON data.id_name_sp_no_vowel = drug_name.name_no_vowel
WHERE uid NOT IN (
  SELECT DISTINCT uid FROM data_has_dp_product UNION SELECT DISTINCT uid FROM data_has_nhp_product
);


-- ------------------------------------------------------------------------------------------------
SELECT "Testing for no-vowel natural matches" AS "";

INSERT INTO data_has_nhp_product( uid, nhp_id, type )
SELECT DISTINCT uid, nhp_id, "no_vowel"
FROM data
JOIN natural_name ON data.id_name_sp_no_vowel = natural_name.name_no_vowel
WHERE uid NOT IN (
  SELECT DISTINCT uid FROM data_has_dp_product UNION SELECT DISTINCT uid FROM data_has_nhp_product
);


-- ------------------------------------------------------------------------------------------------
SELECT "Testing for soundex drug matches" AS "";

INSERT INTO data_has_dp_product( uid, dp_id, type )
SELECT DISTINCT uid, dp_id, "soundex"
FROM data
JOIN drug_name ON data.id_name_sp_soundex = drug_name.name_soundex
WHERE uid NOT IN (
  SELECT DISTINCT uid FROM data_has_dp_product UNION SELECT DISTINCT uid FROM data_has_nhp_product
);


-- ------------------------------------------------------------------------------------------------
SELECT "Testing for soundex natural matches" AS "";

INSERT INTO data_has_nhp_product( uid, nhp_id, type )
SELECT DISTINCT uid, nhp_id, "soundex"
FROM data
JOIN natural_name ON data.id_name_sp_soundex = natural_name.name_soundex
WHERE uid NOT IN (
  SELECT DISTINCT uid FROM data_has_dp_product UNION SELECT DISTINCT uid FROM data_has_nhp_product
);


-- ------------------------------------------------------------------------------------------------
SELECT data.id_name_sp,
       IF( dp_id IS NOT NULL, dp_product.brand_name, IF( nhp_id IS NOT NULL, nhp_product.product_name, "" ) ) AS `match`,
       IF( dp_id IS NOT NULL, "drug", IF( nhp_id IS NOT NULL, "natural", "" ) ) AS `database`,
       IF( dp_id IS NOT NULL, data_has_dp_product.type, IF( nhp_id IS NOT NULL, data_has_nhp_product.type, "" ) ) AS type,
       IF( dp_id IS NOT NULL, COUNT(*), IF( nhp_id IS NOT NULL, COUNT(*), "" ) ) AS multiple,
       IF( dp_id IS NOT NULL, dp_product.din, IF( nhp_id IS NOT NULL, nhp_product.npn, "" ) ) AS code
INTO OUTFILE "matches.csv"
FROM data
LEFT JOIN data_has_dp_product USING( uid )
LEFT JOIN dp_product ON data_has_dp_product.dp_id = dp_product.id
LEFT JOIN data_has_nhp_product USING( uid )
LEFT JOIN nhp_product ON data_has_nhp_product.nhp_id = nhp_product.id
WHERE id_din_sp IS NULL and id_name_sp IS NOT NULL
GROUP BY uid
ORDER BY IF( dp_id IS NOT NULL, "drug", IF( nhp_id IS NOT NULL, "natural", "" ) ),
         IF( dp_id IS NOT NULL, data_has_dp_product.type, IF( nhp_id IS NOT NULL, data_has_nhp_product.type, "" ) ),
         IF( dp_id IS NOT NULL, COUNT(*), IF( nhp_id IS NOT NULL, COUNT(*), "" ) ) DESC,
         id_name_sp;

