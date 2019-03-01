UPDATE data SET match_found = 0;
TRUNCATE data_has_din;
TRUNCATE data_has_npn;

-- ------------------------------------------------------------------------------------------------
SELECT "Testing for predefined DIN matches" AS "";

INSERT INTO data_has_din( uid, din, type, source )
SELECT DISTINCT uid, din, "predefined", "predefined"
FROM data
JOIN prematch
ON id_name_sp_corrected LIKE CONCAT( "%", match1, "%" )
AND IF( match2 IS NULL, 1, id_name_sp_corrected LIKE CONCAT( "%", match2, "%" ) )
AND IF( match3 IS NULL, 1, id_name_sp_corrected LIKE CONCAT( "%", match2, "%" ) )
AND IF( match4 IS NULL, 1, id_name_sp_corrected LIKE CONCAT( "%", match2, "%" ) )
AND IF( match5 IS NULL, 1, id_name_sp_corrected LIKE CONCAT( "%", match2, "%" ) )
WHERE match_found = 0
AND din IS NOT NULL;

SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

UPDATE data JOIN data_has_din USING( uid ) SET match_found = 1;

-- ------------------------------------------------------------------------------------------------
SELECT "Testing for predefined NPN matches" AS "";

INSERT INTO data_has_npn( uid, npn, type, source )
SELECT DISTINCT uid, npn, "predefined", "predefined"
FROM data
JOIN prematch
ON id_name_sp_corrected LIKE CONCAT( "%", match1, "%" )
AND IF( match2 IS NULL, 1, id_name_sp_corrected LIKE CONCAT( "%", match2, "%" ) )
AND IF( match3 IS NULL, 1, id_name_sp_corrected LIKE CONCAT( "%", match2, "%" ) )
AND IF( match4 IS NULL, 1, id_name_sp_corrected LIKE CONCAT( "%", match2, "%" ) )
AND IF( match5 IS NULL, 1, id_name_sp_corrected LIKE CONCAT( "%", match2, "%" ) )
WHERE match_found = 0
AND npn IS NOT NULL;

SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

UPDATE data JOIN data_has_npn USING( uid ) SET match_found = 1;

-- ------------------------------------------------------------------------------------------------
SELECT "Testing for DIN matches" AS "";

INSERT INTO data_has_din( uid, din, type, source )
SELECT DISTINCT uid, dp_product.din, "code", "code"
FROM data
JOIN dp_product ON CONVERT( id_name_sp_code, INT ) = CONVERT( dp_product.din, INT )
WHERE match_found = 0;

SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

UPDATE data JOIN data_has_din USING( uid ) SET match_found = 1;

-- ------------------------------------------------------------------------------------------------
SELECT "Testing for NPN matches" AS "";

INSERT INTO data_has_npn( uid, npn, type, source )
SELECT DISTINCT uid, nhp_product.id, "code", "code"
FROM data
JOIN nhp_product ON CONVERT( id_name_sp_code, INT ) = CONVERT( nhp_product.npn, INT )
WHERE match_found = 0;

SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

UPDATE data JOIN data_has_npn USING( uid ) SET match_found = 1;

-- ------------------------------------------------------------------------------------------------
SELECT "Testing for direct drug matches" AS "";

INSERT INTO data_has_din( uid, din, type, source )
SELECT DISTINCT uid, din, "direct", "product"
FROM data
JOIN drug_name ON id_name_sp_corrected = drug_name.name
WHERE match_found = 0;

SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

UPDATE data JOIN data_has_din USING( uid ) SET match_found = 1;

SELECT "Testing for direct drug ingredient matches" AS "";

INSERT INTO data_has_din( uid, din, type, source )
SELECT DISTINCT uid, din, "direct", "ingredient"
FROM data
JOIN drug_ingredient_name ON id_name_sp_corrected = drug_ingredient_name.name
WHERE match_found = 0;

SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

UPDATE data JOIN data_has_din USING( uid ) SET match_found = 1;

-- ------------------------------------------------------------------------------------------------
SELECT "Testing for direct natural matches" AS "";

INSERT INTO data_has_npn( uid, npn, type, source )
SELECT DISTINCT uid, npn, "direct", "product"
FROM data
JOIN natural_name ON id_name_sp_corrected = natural_name.name
WHERE match_found = 0;

SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

UPDATE data JOIN data_has_npn USING( uid ) SET match_found = 1;

SELECT "Testing for direct natural proper matches" AS "";

INSERT INTO data_has_npn( uid, npn, type, source )
SELECT DISTINCT uid, npn, "direct", "proper"
FROM data
JOIN natural_proper_name ON id_name_sp_corrected = natural_proper_name.name
WHERE match_found = 0;

SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

UPDATE data JOIN data_has_npn USING( uid ) SET match_found = 1;

SELECT "Testing for direct natural common matches" AS "";

INSERT INTO data_has_npn( uid, npn, type, source )
SELECT DISTINCT uid, npn, "direct", "common"
FROM data
JOIN natural_common_name ON id_name_sp_corrected = natural_common_name.name
WHERE match_found = 0;

SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

UPDATE data JOIN data_has_npn USING( uid ) SET match_found = 1;

-- ------------------------------------------------------------------------------------------------
SELECT "Testing for word drug matches" AS "";

INSERT INTO data_has_din( uid, din, type, source )
SELECT DISTINCT uid, din, "word", "product"
FROM data
JOIN drug_name ON CHAR_LENGTH( name ) > 3
AND id_name_sp_corrected RLIKE CONCAT(
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
WHERE match_found = 0;

SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

UPDATE data JOIN data_has_din USING( uid ) SET match_found = 1;

SELECT "Testing for word drug ingredient matches" AS "";

INSERT INTO data_has_din( uid, din, type, source )
SELECT DISTINCT uid, din, "word", "ingredient"
FROM data
JOIN drug_ingredient_name ON CHAR_LENGTH( name ) > 3
AND id_name_sp_corrected RLIKE CONCAT(
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
WHERE match_found = 0;

SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

UPDATE data JOIN data_has_din USING( uid ) SET match_found = 1;

-- ------------------------------------------------------------------------------------------------
SELECT "Testing for word natural matches" AS "";

INSERT INTO data_has_npn( uid, npn, type, source )
SELECT DISTINCT uid, npn, "word", "product"
FROM data
JOIN natural_name ON CHAR_LENGTH( name ) > 3
AND id_name_sp_corrected RLIKE CONCAT(
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
WHERE match_found = 0;

SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

UPDATE data JOIN data_has_npn USING( uid ) SET match_found = 1;

SELECT "Testing for word natural proper matches" AS "";

INSERT INTO data_has_npn( uid, npn, type, source )
SELECT DISTINCT uid, npn, "word", "proper"
FROM data
JOIN natural_proper_name ON CHAR_LENGTH( name ) > 3
AND id_name_sp_corrected RLIKE CONCAT(
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
WHERE match_found = 0;

SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

UPDATE data JOIN data_has_npn USING( uid ) SET match_found = 1;

SELECT "Testing for word natural common matches" AS "";

INSERT INTO data_has_npn( uid, npn, type, source )
SELECT DISTINCT uid, npn, "word", "common"
FROM data
JOIN natural_common_name ON CHAR_LENGTH( name ) > 3
AND id_name_sp_corrected RLIKE CONCAT(
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
WHERE match_found = 0;

SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

UPDATE data JOIN data_has_npn USING( uid ) SET match_found = 1;

-- ------------------------------------------------------------------------------------------------
SELECT "Testing for reverse-word drug matches" AS "";

INSERT INTO data_has_din( uid, din, type, source )
SELECT DISTINCT uid, din, "reverse-word", "product"
FROM data
JOIN drug_name ON CHAR_LENGTH( id_name_sp_corrected ) > 3
AND name RLIKE CONCAT(
  "( |^)",
  REPLACE(
    REPLACE(
      REPLACE(
        REPLACE(
          REPLACE(
            id_name_sp_corrected,
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
WHERE match_found = 0;

SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

UPDATE data JOIN data_has_din USING( uid ) SET match_found = 1;

SELECT "Testing for reverse-word drug ingredient matches" AS "";

INSERT INTO data_has_din( uid, din, type, source )
SELECT DISTINCT uid, din, "reverse-word", "ingredient"
FROM data
JOIN drug_ingredient_name ON CHAR_LENGTH( id_name_sp_corrected ) > 3
AND name RLIKE CONCAT(
  "( |^)",
  REPLACE(
    REPLACE(
      REPLACE(
        REPLACE(
          REPLACE(
            id_name_sp_corrected,
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
WHERE match_found = 0;

SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

UPDATE data JOIN data_has_din USING( uid ) SET match_found = 1;

-- ------------------------------------------------------------------------------------------------
SELECT "Testing for simplified drug matches" AS "";

INSERT INTO data_has_din( uid, din, type, source )
SELECT DISTINCT uid, din, "simple", "product"
FROM data
JOIN drug_name ON data.id_name_sp_simple = drug_name.name_simple
WHERE match_found = 0;

SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

UPDATE data JOIN data_has_din USING( uid ) SET match_found = 1;

SELECT "Testing for simplified drug ingredient matches" AS "";

INSERT INTO data_has_din( uid, din, type, source )
SELECT DISTINCT uid, din, "simple", "ingredient"
FROM data
JOIN drug_ingredient_name ON data.id_name_sp_simple = drug_ingredient_name.name_simple
WHERE match_found = 0;

SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

UPDATE data JOIN data_has_din USING( uid ) SET match_found = 1;

-- ------------------------------------------------------------------------------------------------
SELECT "Testing for simplified natural matches" AS "";

INSERT INTO data_has_npn( uid, npn, type, source )
SELECT DISTINCT uid, npn, "simple", "product"
FROM data
JOIN natural_name ON data.id_name_sp_simple = natural_name.name_simple
WHERE match_found = 0;

SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

UPDATE data JOIN data_has_npn USING( uid ) SET match_found = 1;

SELECT "Testing for simplified natural proper matches" AS "";

INSERT INTO data_has_npn( uid, npn, type, source )
SELECT DISTINCT uid, npn, "simple", "proper"
FROM data
JOIN natural_proper_name ON data.id_name_sp_simple = natural_proper_name.name_simple
WHERE match_found = 0;

SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

UPDATE data JOIN data_has_npn USING( uid ) SET match_found = 1;

SELECT "Testing for simplified natural common matches" AS "";

INSERT INTO data_has_npn( uid, npn, type, source )
SELECT DISTINCT uid, npn, "simple", "common"
FROM data
JOIN natural_common_name ON data.id_name_sp_simple = natural_common_name.name_simple
WHERE match_found = 0;

SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

UPDATE data JOIN data_has_npn USING( uid ) SET match_found = 1;

-- ------------------------------------------------------------------------------------------------
SELECT "Testing for no-parentheses drug matches" AS "";

INSERT INTO data_has_din( uid, din, type, source )
SELECT DISTINCT uid, din, "no-parens", "product"
FROM data
JOIN drug_name ON data.id_name_sp_no_parens = drug_name.name_no_parens
WHERE match_found = 0;

SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

UPDATE data JOIN data_has_din USING( uid ) SET match_found = 1;

SELECT "Testing for no-parentheses drug ingredient matches" AS "";

INSERT INTO data_has_din( uid, din, type, source )
SELECT DISTINCT uid, din, "no-parens", "ingredient"
FROM data
JOIN drug_ingredient_name ON data.id_name_sp_no_parens = drug_ingredient_name.name_no_parens
WHERE match_found = 0;

SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

UPDATE data JOIN data_has_din USING( uid ) SET match_found = 1;

-- ------------------------------------------------------------------------------------------------
SELECT "Testing for no-parentheses natural matches" AS "";

INSERT INTO data_has_npn( uid, npn, type, source )
SELECT DISTINCT uid, npn, "no-parens", "product"
FROM data
JOIN natural_name ON data.id_name_sp_no_parens = natural_name.name_no_parens
WHERE match_found = 0;

SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

UPDATE data JOIN data_has_npn USING( uid ) SET match_found = 1;

SELECT "Testing for no-parentheses natural proper matches" AS "";

INSERT INTO data_has_npn( uid, npn, type, source )
SELECT DISTINCT uid, npn, "no-parens", "proper"
FROM data
JOIN natural_proper_name ON data.id_name_sp_no_parens = natural_proper_name.name_no_parens
WHERE match_found = 0;

SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

UPDATE data JOIN data_has_npn USING( uid ) SET match_found = 1;

SELECT "Testing for no-parentheses natural common matches" AS "";

INSERT INTO data_has_npn( uid, npn, type, source )
SELECT DISTINCT uid, npn, "no-parens", "common"
FROM data
JOIN natural_common_name ON data.id_name_sp_no_parens = natural_common_name.name_no_parens
WHERE match_found = 0;

SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

UPDATE data JOIN data_has_npn USING( uid ) SET match_found = 1;

-- ------------------------------------------------------------------------------------------------
SELECT "Testing for no-units drug matches" AS "";

INSERT INTO data_has_din( uid, din, type, source )
SELECT DISTINCT uid, din, "no-units", "product"
FROM data
JOIN drug_name ON data.id_name_sp_no_units = drug_name.name_no_units
WHERE match_found = 0;

SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

UPDATE data JOIN data_has_din USING( uid ) SET match_found = 1;

SELECT "Testing for no-units drug ingredient matches" AS "";

INSERT INTO data_has_din( uid, din, type, source )
SELECT DISTINCT uid, din, "no-units", "ingredient"
FROM data
JOIN drug_ingredient_name ON data.id_name_sp_no_units = drug_ingredient_name.name_no_units
WHERE match_found = 0;

SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

UPDATE data JOIN data_has_din USING( uid ) SET match_found = 1;

-- ------------------------------------------------------------------------------------------------
SELECT "Testing for no-units natural matches" AS "";

INSERT INTO data_has_npn( uid, npn, type, source )
SELECT DISTINCT uid, npn, "no-units", "product"
FROM data
JOIN natural_name ON data.id_name_sp_no_units = natural_name.name_no_units
WHERE match_found = 0;

SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

UPDATE data JOIN data_has_npn USING( uid ) SET match_found = 1;

SELECT "Testing for no-units natural proper matches" AS "";

INSERT INTO data_has_npn( uid, npn, type, source )
SELECT DISTINCT uid, npn, "no-units", "proper"
FROM data
JOIN natural_proper_name ON data.id_name_sp_no_units = natural_proper_name.name_no_units
WHERE match_found = 0;

SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

UPDATE data JOIN data_has_npn USING( uid ) SET match_found = 1;

SELECT "Testing for no-units natural common matches" AS "";

INSERT INTO data_has_npn( uid, npn, type, source )
SELECT DISTINCT uid, npn, "no-units", "common"
FROM data
JOIN natural_common_name ON data.id_name_sp_no_units = natural_common_name.name_no_units
WHERE match_found = 0;

SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

UPDATE data JOIN data_has_npn USING( uid ) SET match_found = 1;

-- ------------------------------------------------------------------------------------------------
-- SELECT "Removing data that has more than 5 matches" AS "";
-- 
-- DELETE FROM data_has_din
-- WHERE uid IN ( SELECT uid FROM ( SELECT uid FROM data_has_din GROUP BY uid HAVING COUNT(*) > 5 ) AS temp );
-- 
-- SELECT CONCAT( ROW_COUNT(), " drug matches removed" ) AS "";
-- 
-- DELETE FROM data_has_npn
-- WHERE uid IN ( SELECT uid FROM ( SELECT uid FROM data_has_npn GROUP BY uid HAVING COUNT(*) > 5 ) AS temp );
-- 
-- SELECT CONCAT( ROW_COUNT(), " natural matches removed" ) AS "";
-- 
-- UPDATE data
-- LEFT JOIN data_has_din USING (uid)
-- LEFT JOIN data_has_npn USING (uid)
-- SET match_found = 0
-- WHERE din IS NULL AND npn IS NULL;

-- ------------------------------------------------------------------------------------------------
SELECT "Replacing multiple matches with lowest ranking DIN or NPN" AS "";

ALTER TABLE data_has_din
ADD COLUMN first TINYINT(1) DEFAULT 0;

DROP TABLE IF EXISTS first_din;
CREATE TEMPORARY TABLE first_din
SELECT DISTINCT uid, MIN( din ) AS din
FROM data_has_din
GROUP BY uid;
ALTER TABLE first_din ADD INDEX dk_din( din );

UPDATE data_has_din
JOIN first_din USING( uid, din )
SET first = 1;

DELETE FROM data_has_din WHERE first = 0;
ALTER TABLE data_has_din DROP COLUMN first;

ALTER TABLE data_has_npn
ADD COLUMN first TINYINT(1) DEFAULT 0;

CREATE TEMPORARY TABLE first_npn
SELECT DISTINCT uid, MIN( npn ) AS npn
FROM data_has_npn
GROUP BY uid;
ALTER TABLE first_npn ADD INDEX dk_npn( npn );

UPDATE data_has_npn
JOIN first_npn USING( uid, npn )
SET first = 1;

DELETE FROM data_has_npn WHERE first = 0;
ALTER TABLE data_has_npn DROP COLUMN first;
