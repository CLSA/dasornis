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
SELECT "Testing for word drug matches" AS "";

INSERT INTO data_has_dp_product( uid, dp_id, type )
SELECT DISTINCT uid, dp_id, "word"
FROM data
JOIN drug_name ON CHAR_LENGTH( name ) > 3
AND id_name_sp RLIKE CONCAT(
  "( |^)",
  REPLACE(
    REPLACE(
      REPLACE(
        REPLACE(
          REPLACE(
            name,
            ".",
            "[.]"
          ),
          "+",
          "[+]"
        ),
        "(",
        "[(]"
      ),
      ")",
      "[)]"
    ),
    "|",
    "[|]"
  ),
  "( |$)"
)
WHERE uid NOT IN (
  SELECT DISTINCT uid FROM data_has_dp_product UNION SELECT DISTINCT uid FROM data_has_nhp_product
);


-- ------------------------------------------------------------------------------------------------
SELECT "Testing for word natural matches" AS "";

INSERT INTO data_has_nhp_product( uid, nhp_id, type )
SELECT DISTINCT uid, nhp_id, "word"
FROM data
JOIN natural_name ON CHAR_LENGTH( name ) > 3
AND id_name_sp RLIKE CONCAT(
  "( |^)",
  REPLACE(
    REPLACE(
      REPLACE(
        REPLACE(
          REPLACE(
            name,
            ".",
            "[.]"
          ),
          "+",
          "[+]"
        ),
        "(",
        "[(]"
      ),
      ")",
      "[)]"
    ),
    "|",
    "[|]"
  ),
  "( |$)"
)
WHERE uid NOT IN (
  SELECT DISTINCT uid FROM data_has_dp_product UNION SELECT DISTINCT uid FROM data_has_nhp_product
);


-- ------------------------------------------------------------------------------------------------
-- SELECT "Testing for reverse-word drug matches" AS "";
-- 
-- INSERT INTO data_has_dp_product( uid, dp_id, type )
-- SELECT DISTINCT uid, dp_id, "reverse-word"
-- FROM data
-- JOIN drug_name ON CHAR_LENGTH( id_name_sp ) > 3
-- AND name RLIKE CONCAT(
--   "( |^)",
--   REPLACE(
--     REPLACE(
--       REPLACE(
--         REPLACE(
--           REPLACE(
--             id_name_sp,
--             ".",
--             "[.]"
--           ),
--           "+",
--           "[+]"
--         ),
--         "(",
--         "[(]"
--       ),
--       ")",
--       "[)]"
--     ),
--     "|",
--     "[|]"
--   ),
--   "( |$)"
-- )
-- WHERE uid NOT IN (
--   SELECT DISTINCT uid FROM data_has_dp_product UNION SELECT DISTINCT uid FROM data_has_nhp_product
-- );


-- ------------------------------------------------------------------------------------------------
-- SELECT "Testing for reverse-word natural matches" AS "";
-- 
-- INSERT INTO data_has_nhp_product( uid, nhp_id, type )
-- SELECT DISTINCT uid, nhp_id, "reverse-word"
-- FROM data
-- JOIN natural_name ON CHAR_LENGTH( id_name_sp ) > 3
-- AND name RLIKE CONCAT(
--   "( |^)",
--   REPLACE(
--     REPLACE(
--       REPLACE(
--         REPLACE(
--           REPLACE(
--             id_name_sp,
--             ".",
--             "[.]"
--           ),
--           "+",
--           "[+]"
--         ),
--         "(",
--         "[(]"
--       ),
--       ")",
--       "[)]"
--     ),
--     "|",
--     "[|]"
--   ),
--   "( |$)"
-- )
-- WHERE uid NOT IN (
--   SELECT DISTINCT uid FROM data_has_dp_product UNION SELECT DISTINCT uid FROM data_has_nhp_product
-- );


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
-- SELECT "Testing for no-vowel drug matches" AS "";
-- 
-- INSERT INTO data_has_dp_product( uid, dp_id, type )
-- SELECT DISTINCT uid, dp_id, "no-vowel"
-- FROM data
-- JOIN drug_name ON data.id_name_sp_no_vowel = drug_name.name_no_vowel
-- WHERE uid NOT IN (
--   SELECT DISTINCT uid FROM data_has_dp_product UNION SELECT DISTINCT uid FROM data_has_nhp_product
-- );


-- ------------------------------------------------------------------------------------------------
-- SELECT "Testing for no-vowel natural matches" AS "";
-- 
-- INSERT INTO data_has_nhp_product( uid, nhp_id, type )
-- SELECT DISTINCT uid, nhp_id, "no-vowel"
-- FROM data
-- JOIN natural_name ON data.id_name_sp_no_vowel = natural_name.name_no_vowel
-- WHERE uid NOT IN (
--   SELECT DISTINCT uid FROM data_has_dp_product UNION SELECT DISTINCT uid FROM data_has_nhp_product
-- );


-- ------------------------------------------------------------------------------------------------
-- SELECT "Testing for soundex drug matches" AS "";
-- 
-- INSERT INTO data_has_dp_product( uid, dp_id, type )
-- SELECT DISTINCT uid, dp_id, "soundex"
-- FROM data
-- JOIN drug_name ON data.id_name_sp_soundex = drug_name.name_soundex
-- WHERE uid NOT IN (
--   SELECT DISTINCT uid FROM data_has_dp_product UNION SELECT DISTINCT uid FROM data_has_nhp_product
-- );


-- ------------------------------------------------------------------------------------------------
-- SELECT "Testing for soundex natural matches" AS "";
-- 
-- INSERT INTO data_has_nhp_product( uid, nhp_id, type )
-- SELECT DISTINCT uid, nhp_id, "soundex"
-- FROM data
-- JOIN natural_name ON data.id_name_sp_soundex = natural_name.name_soundex
-- WHERE uid NOT IN (
--   SELECT DISTINCT uid FROM data_has_dp_product UNION SELECT DISTINCT uid FROM data_has_nhp_product
-- );


-- ------------------------------------------------------------------------------------------------
SELECT "Marking data with multiple matches" AS "";

CREATE TEMPORARY TABLE multiple ( PRIMARY KEY (uid) )
SELECT DISTINCT uid FROM data_has_dp_product GROUP BY uid HAVING COUNT(*) = 1 UNION
SELECT DISTINCT uid FROM data_has_nhp_product GROUP BY uid HAVING COUNT(*) = 1;
UPDATE data JOIN multiple USING( uid ) SET multiple = 0;
DROP TABLE multiple;

CREATE TEMPORARY TABLE multiple ( PRIMARY KEY (uid) )
SELECT DISTINCT uid FROM data_has_dp_product GROUP BY uid HAVING COUNT(*) > 1 UNION
SELECT DISTINCT uid FROM data_has_nhp_product GROUP BY uid HAVING COUNT(*) > 1;
UPDATE data JOIN multiple USING( uid ) SET multiple = 1;

-- ------------------------------------------------------------------------------------------------
SELECT "Removing data that has more than 5 matches" AS "";

DELETE FROM data_has_dp_product
WHERE uid IN ( SELECT uid FROM ( SELECT uid FROM data_has_dp_product GROUP BY uid HAVING COUNT(*) > 5 ) AS temp );

DELETE FROM data_has_nhp_product
WHERE uid IN ( SELECT uid FROM ( SELECT uid FROM data_has_nhp_product GROUP BY uid HAVING COUNT(*) > 5 ) AS temp );
