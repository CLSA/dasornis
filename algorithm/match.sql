UPDATE data SET match_found = 0;
TRUNCATE data_has_din;
TRUNCATE data_has_npn;

-- ------------------------------------------------------------------------------------------------
SELECT "Testing for manual-match DIN matches" AS "";

INSERT INTO data_has_din( identifier, din, type, source )
SELECT DISTINCT identifier, din, "manual-match", "manual-match"
FROM data
JOIN manual_match USING (input)
WHERE match_found = 0
AND din IS NOT NULL;

-- SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

UPDATE data JOIN data_has_din USING( identifier ) SET match_found = 1;

-- ------------------------------------------------------------------------------------------------
SELECT "Testing for manual-match NPN matches" AS "";

INSERT INTO data_has_npn( identifier, npn, type, source )
SELECT DISTINCT identifier, npn, "manual-match", "manual-match"
FROM data
JOIN manual_match USING (input)
WHERE match_found = 0
AND npn IS NOT NULL;

-- SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

UPDATE data JOIN data_has_npn USING( identifier ) SET match_found = 1;

-- ------------------------------------------------------------------------------------------------
SELECT "Testing for pre-match DIN matches" AS "";

INSERT INTO data_has_din( identifier, din, type, source )
SELECT DISTINCT identifier, din, "pre-match", "pre-match"
FROM data
JOIN pre_match
ON input_corrected LIKE CONCAT( "%", match1, "%" )
AND IF( match2 IS NULL, 1, input_corrected LIKE CONCAT( "%", match2, "%" ) )
AND IF( match3 IS NULL, 1, input_corrected LIKE CONCAT( "%", match3, "%" ) )
AND IF( match4 IS NULL, 1, input_corrected LIKE CONCAT( "%", match4, "%" ) )
AND IF( match5 IS NULL, 1, input_corrected LIKE CONCAT( "%", match5, "%" ) )
WHERE match_found = 0
AND din IS NOT NULL;

-- SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

UPDATE data JOIN data_has_din USING( identifier ) SET match_found = 1;

-- ------------------------------------------------------------------------------------------------
SELECT "Testing for pre-match NPN matches" AS "";

INSERT INTO data_has_npn( identifier, npn, type, source )
SELECT DISTINCT identifier, npn, "pre-match", "pre-match"
FROM data
JOIN pre_match
ON input_corrected LIKE CONCAT( "%", match1, "%" )
AND IF( match2 IS NULL, 1, input_corrected LIKE CONCAT( "%", match2, "%" ) )
AND IF( match3 IS NULL, 1, input_corrected LIKE CONCAT( "%", match3, "%" ) )
AND IF( match4 IS NULL, 1, input_corrected LIKE CONCAT( "%", match4, "%" ) )
AND IF( match5 IS NULL, 1, input_corrected LIKE CONCAT( "%", match5, "%" ) )
WHERE match_found = 0
AND npn IS NOT NULL;

-- SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

UPDATE data JOIN data_has_npn USING( identifier ) SET match_found = 1;

-- ------------------------------------------------------------------------------------------------
SELECT "Testing for DIN matches" AS "";

INSERT INTO data_has_din( identifier, din, type, source )
SELECT DISTINCT identifier, dp_product.din, "code", "code"
FROM data
JOIN dp_product ON CONVERT( input_code, INT ) = CONVERT( dp_product.din, INT )
WHERE match_found = 0;

-- SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

UPDATE data JOIN data_has_din USING( identifier ) SET match_found = 1;

-- ------------------------------------------------------------------------------------------------
SELECT "Testing for NPN matches" AS "";

INSERT INTO data_has_npn( identifier, npn, type, source )
SELECT DISTINCT identifier, lnhpd_product.npn, "code", "code"
FROM data
JOIN lnhpd_product ON CONVERT( input_code, INT ) = CONVERT( lnhpd_product.npn, INT )
WHERE match_found = 0;

-- SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

UPDATE data JOIN data_has_npn USING( identifier ) SET match_found = 1;

-- ------------------------------------------------------------------------------------------------
SELECT "Testing for direct drug matches" AS "";

INSERT INTO data_has_din( identifier, din, type, source )
SELECT DISTINCT identifier, din, "direct", "product"
FROM data
JOIN drug_name ON input_corrected = drug_name.name
WHERE match_found = 0
AND drug_name.din IS NOT NULL;

-- SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

UPDATE data JOIN data_has_din USING( identifier ) SET match_found = 1;

SELECT "Testing for direct drug ingredient matches" AS "";

INSERT INTO data_has_din( identifier, din, type, source )
SELECT DISTINCT identifier, din, "direct", "ingredient"
FROM data
JOIN drug_ingredient_name ON input_corrected = drug_ingredient_name.name
WHERE match_found = 0;

-- SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

UPDATE data JOIN data_has_din USING( identifier ) SET match_found = 1;

-- ------------------------------------------------------------------------------------------------
SELECT "Testing for direct natural matches" AS "";

INSERT INTO data_has_npn( identifier, npn, type, source )
SELECT DISTINCT identifier, npn, "direct", "product"
FROM data
JOIN natural_name ON input_corrected = natural_name.name
WHERE match_found = 0;

-- SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

UPDATE data JOIN data_has_npn USING( identifier ) SET match_found = 1;

SELECT "Testing for direct natural ingredient matches" AS "";

INSERT INTO data_has_npn( identifier, npn, type, source )
SELECT DISTINCT identifier, npn, "direct", "ingredient"
FROM data
JOIN natural_ingredient_name ON input_corrected = natural_ingredient_name.name
WHERE match_found = 0;

-- SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

UPDATE data JOIN data_has_npn USING( identifier ) SET match_found = 1;

-- ------------------------------------------------------------------------------------------------
SELECT "Testing for word drug matches" AS "";

INSERT INTO data_has_din( identifier, din, type, source )
SELECT DISTINCT identifier, din, "word", "product"
FROM data
JOIN drug_name ON CHAR_LENGTH( name ) > 3
AND input_corrected RLIKE CONCAT(
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
WHERE match_found = 0
AND drug_name.din IS NOT NULL;

-- SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

UPDATE data JOIN data_has_din USING( identifier ) SET match_found = 1;

SELECT "Testing for word drug ingredient matches" AS "";

INSERT INTO data_has_din( identifier, din, type, source )
SELECT DISTINCT identifier, din, "word", "ingredient"
FROM data
JOIN drug_ingredient_name ON CHAR_LENGTH( name ) > 3
AND input_corrected RLIKE CONCAT(
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

-- SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

UPDATE data JOIN data_has_din USING( identifier ) SET match_found = 1;

-- ------------------------------------------------------------------------------------------------
SELECT "Testing for word natural matches" AS "";

INSERT INTO data_has_npn( identifier, npn, type, source )
SELECT DISTINCT identifier, npn, "word", "product"
FROM data
JOIN natural_name ON CHAR_LENGTH( name ) > 3
AND input_corrected RLIKE CONCAT(
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

-- SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

UPDATE data JOIN data_has_npn USING( identifier ) SET match_found = 1;

SELECT "Testing for word natural ingredient matches" AS "";

INSERT INTO data_has_npn( identifier, npn, type, source )
SELECT DISTINCT identifier, npn, "word", "ingredient"
FROM data
JOIN natural_ingredient_name ON CHAR_LENGTH( name ) > 3
AND input_corrected RLIKE CONCAT(
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

-- SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

UPDATE data JOIN data_has_npn USING( identifier ) SET match_found = 1;

-- ------------------------------------------------------------------------------------------------
SELECT "Testing for reverse-word drug matches" AS "";

INSERT INTO data_has_din( identifier, din, type, source )
SELECT DISTINCT identifier, din, "reverse-word", "product"
FROM data
JOIN drug_name ON CHAR_LENGTH( input_corrected ) > 3
AND name RLIKE CONCAT(
  "( |^)",
  REPLACE(
    REPLACE(
      REPLACE(
        REPLACE(
          REPLACE(
            input_corrected,
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
WHERE match_found = 0
AND drug_name.din IS NOT NULL;

-- SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

UPDATE data JOIN data_has_din USING( identifier ) SET match_found = 1;

SELECT "Testing for reverse-word drug ingredient matches" AS "";

INSERT INTO data_has_din( identifier, din, type, source )
SELECT DISTINCT identifier, din, "reverse-word", "ingredient"
FROM data
JOIN drug_ingredient_name ON CHAR_LENGTH( input_corrected ) > 3
AND name RLIKE CONCAT(
  "( |^)",
  REPLACE(
    REPLACE(
      REPLACE(
        REPLACE(
          REPLACE(
            input_corrected,
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

-- SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

UPDATE data JOIN data_has_din USING( identifier ) SET match_found = 1;

-- ------------------------------------------------------------------------------------------------
SELECT "Testing for simplified drug matches" AS "";

INSERT INTO data_has_din( identifier, din, type, source )
SELECT DISTINCT identifier, din, "simple", "product"
FROM data
JOIN drug_name ON data.input_simple = drug_name.name_simple
WHERE match_found = 0
AND drug_name.din IS NOT NULL
AND data.input_simple != "";

-- SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

UPDATE data JOIN data_has_din USING( identifier ) SET match_found = 1;

SELECT "Testing for simplified drug ingredient matches" AS "";

INSERT INTO data_has_din( identifier, din, type, source )
SELECT DISTINCT identifier, din, "simple", "ingredient"
FROM data
JOIN drug_ingredient_name ON data.input_simple = drug_ingredient_name.name_simple
WHERE match_found = 0
AND data.input_simple != "";

-- SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

UPDATE data JOIN data_has_din USING( identifier ) SET match_found = 1;

-- ------------------------------------------------------------------------------------------------
SELECT "Testing for simplified natural matches" AS "";

INSERT INTO data_has_npn( identifier, npn, type, source )
SELECT DISTINCT identifier, npn, "simple", "product"
FROM data
JOIN natural_name ON data.input_simple = natural_name.name_simple
WHERE match_found = 0
AND data.input_simple != "";

-- SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

UPDATE data JOIN data_has_npn USING( identifier ) SET match_found = 1;

SELECT "Testing for simplified natural ingredient matches" AS "";

INSERT INTO data_has_npn( identifier, npn, type, source )
SELECT DISTINCT identifier, npn, "simple", "ingredient"
FROM data
JOIN natural_ingredient_name ON data.input_simple = natural_ingredient_name.name_simple
WHERE match_found = 0
AND data.input_simple != "";

-- SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

UPDATE data JOIN data_has_npn USING( identifier ) SET match_found = 1;

-- ------------------------------------------------------------------------------------------------
SELECT "Testing for no-parentheses drug matches" AS "";

INSERT INTO data_has_din( identifier, din, type, source )
SELECT DISTINCT identifier, din, "no-parens", "product"
FROM data
JOIN drug_name ON data.input_no_parens = drug_name.name_no_parens
WHERE match_found = 0
AND drug_name.din IS NOT NULL;

-- SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

UPDATE data JOIN data_has_din USING( identifier ) SET match_found = 1;

SELECT "Testing for no-parentheses drug ingredient matches" AS "";

INSERT INTO data_has_din( identifier, din, type, source )
SELECT DISTINCT identifier, din, "no-parens", "ingredient"
FROM data
JOIN drug_ingredient_name ON data.input_no_parens = drug_ingredient_name.name_no_parens
WHERE match_found = 0;

-- SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

UPDATE data JOIN data_has_din USING( identifier ) SET match_found = 1;

-- ------------------------------------------------------------------------------------------------
SELECT "Testing for no-parentheses natural matches" AS "";

INSERT INTO data_has_npn( identifier, npn, type, source )
SELECT DISTINCT identifier, npn, "no-parens", "product"
FROM data
JOIN natural_name ON data.input_no_parens = natural_name.name_no_parens
WHERE match_found = 0;

-- SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

UPDATE data JOIN data_has_npn USING( identifier ) SET match_found = 1;

SELECT "Testing for no-parentheses natural ingredient matches" AS "";

INSERT INTO data_has_npn( identifier, npn, type, source )
SELECT DISTINCT identifier, npn, "no-parens", "ingredient"
FROM data
JOIN natural_ingredient_name ON data.input_no_parens = natural_ingredient_name.name_no_parens
WHERE match_found = 0;

-- SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

UPDATE data JOIN data_has_npn USING( identifier ) SET match_found = 1;

-- ------------------------------------------------------------------------------------------------
SELECT "Testing for no-units drug matches" AS "";

INSERT INTO data_has_din( identifier, din, type, source )
SELECT DISTINCT identifier, din, "no-units", "product"
FROM data
JOIN drug_name ON data.input_no_units = drug_name.name_no_units
WHERE match_found = 0
AND drug_name.din IS NOT NULL;

-- SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

UPDATE data JOIN data_has_din USING( identifier ) SET match_found = 1;

SELECT "Testing for no-units drug ingredient matches" AS "";

INSERT INTO data_has_din( identifier, din, type, source )
SELECT DISTINCT identifier, din, "no-units", "ingredient"
FROM data
JOIN drug_ingredient_name ON data.input_no_units = drug_ingredient_name.name_no_units
WHERE match_found = 0;

-- SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

UPDATE data JOIN data_has_din USING( identifier ) SET match_found = 1;

-- ------------------------------------------------------------------------------------------------
SELECT "Testing for no-units natural matches" AS "";

INSERT INTO data_has_npn( identifier, npn, type, source )
SELECT DISTINCT identifier, npn, "no-units", "product"
FROM data
JOIN natural_name ON data.input_no_units = natural_name.name_no_units
WHERE match_found = 0;

-- SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

UPDATE data JOIN data_has_npn USING( identifier ) SET match_found = 1;

SELECT "Testing for no-units natural ingredient matches" AS "";

INSERT INTO data_has_npn( identifier, npn, type, source )
SELECT DISTINCT identifier, npn, "no-units", "ingredient"
FROM data
JOIN natural_ingredient_name ON data.input_no_units = natural_ingredient_name.name_no_units
WHERE match_found = 0;

-- SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

UPDATE data JOIN data_has_npn USING( identifier ) SET match_found = 1;

-- ------------------------------------------------------------------------------------------------
SELECT "Replacing multiple matches with lowest ranking DIN or NPN" AS "";

ALTER TABLE data_has_din
ADD COLUMN first TINYINT(1) DEFAULT 0;

DROP TABLE IF EXISTS first_din;
CREATE TEMPORARY TABLE first_din
SELECT DISTINCT identifier, MIN( din ) AS din
FROM data_has_din
GROUP BY identifier;
ALTER TABLE first_din ADD INDEX dk_din( din );

UPDATE data_has_din
JOIN first_din USING( identifier, din )
SET first = 1;

DELETE FROM data_has_din WHERE first = 0;
ALTER TABLE data_has_din DROP COLUMN first;

ALTER TABLE data_has_npn
ADD COLUMN first TINYINT(1) DEFAULT 0;

CREATE TEMPORARY TABLE first_npn
SELECT DISTINCT identifier, MIN( npn ) AS npn
FROM data_has_npn
GROUP BY identifier;
ALTER TABLE first_npn ADD INDEX dk_npn( npn );

UPDATE data_has_npn
JOIN first_npn USING( identifier, npn )
SET first = 1;

DELETE FROM data_has_npn WHERE first = 0;
ALTER TABLE data_has_npn DROP COLUMN first;
