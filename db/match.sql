TRUNCATE data_has_dp_product;
TRUNCATE data_has_nhp_product;

-- ------------------------------------------------------------------------------------------------
SELECT "Testing for direct drug matches" AS "";

INSERT INTO data_has_dp_product( uid, dp_id, type )
SELECT DISTINCT uid, dp_id, "direct"
FROM data
JOIN drug_name ON id_name_sp_corrected = drug_name.name;

SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

-- ------------------------------------------------------------------------------------------------
SELECT "Testing for direct natural matches" AS "";

INSERT INTO data_has_nhp_product( uid, nhp_id, type )
SELECT DISTINCT uid, nhp_id, "direct"
FROM data
JOIN natural_name ON id_name_sp_corrected = natural_name.name
WHERE uid NOT IN (
  SELECT DISTINCT uid FROM data_has_dp_product UNION SELECT DISTINCT uid FROM data_has_nhp_product
);

SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

-- ------------------------------------------------------------------------------------------------
SELECT "Testing for DIN matches" AS "";

INSERT INTO data_has_dp_product( uid, dp_id, type )
SELECT DISTINCT uid, dp_product.id, "code"
FROM data
JOIN dp_product ON id_name_sp_code = dp_product.din
WHERE uid NOT IN (
  SELECT DISTINCT uid FROM data_has_dp_product UNION SELECT DISTINCT uid FROM data_has_nhp_product
);

SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

-- ------------------------------------------------------------------------------------------------
SELECT "Testing for NPN matches" AS "";

INSERT INTO data_has_nhp_product( uid, nhp_id, type )
SELECT DISTINCT uid, nhp_product.id, "code"
FROM data
JOIN nhp_product ON id_name_sp_code = nhp_product.npn
WHERE uid NOT IN (
  SELECT DISTINCT uid FROM data_has_dp_product UNION SELECT DISTINCT uid FROM data_has_nhp_product
);

SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

-- ------------------------------------------------------------------------------------------------
SELECT "Testing for word drug matches" AS "";

INSERT INTO data_has_dp_product( uid, dp_id, type )
SELECT DISTINCT uid, dp_id, "word"
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
WHERE uid NOT IN (
  SELECT DISTINCT uid FROM data_has_dp_product UNION SELECT DISTINCT uid FROM data_has_nhp_product
);

SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

-- ------------------------------------------------------------------------------------------------
SELECT "Testing for word natural matches" AS "";

INSERT INTO data_has_nhp_product( uid, nhp_id, type )
SELECT DISTINCT uid, nhp_id, "word"
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
WHERE uid NOT IN (
  SELECT DISTINCT uid FROM data_has_dp_product UNION SELECT DISTINCT uid FROM data_has_nhp_product
);

SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

-- ------------------------------------------------------------------------------------------------
SELECT "Testing for simplified drug matches" AS "";

INSERT INTO data_has_dp_product( uid, dp_id, type )
SELECT DISTINCT uid, dp_id, "simple"
FROM data
JOIN drug_name ON data.id_name_sp_simple = drug_name.name_simple
WHERE uid NOT IN (
  SELECT DISTINCT uid FROM data_has_dp_product UNION SELECT DISTINCT uid FROM data_has_nhp_product
);

SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

-- ------------------------------------------------------------------------------------------------
SELECT "Testing for simplified natural matches" AS "";

INSERT INTO data_has_nhp_product( uid, nhp_id, type )
SELECT DISTINCT uid, nhp_id, "simple"
FROM data
JOIN natural_name ON data.id_name_sp_simple = natural_name.name_simple
WHERE uid NOT IN (
  SELECT DISTINCT uid FROM data_has_dp_product UNION SELECT DISTINCT uid FROM data_has_nhp_product
);

SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

-- ------------------------------------------------------------------------------------------------
SELECT "Testing for no-parentheses drug matches" AS "";

INSERT INTO data_has_dp_product( uid, dp_id, type )
SELECT DISTINCT uid, dp_id, "no-parens"
FROM data
JOIN drug_name ON data.id_name_sp_no_parens = drug_name.name_no_parens
WHERE uid NOT IN (
  SELECT DISTINCT uid FROM data_has_dp_product UNION SELECT DISTINCT uid FROM data_has_nhp_product
);

SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

-- ------------------------------------------------------------------------------------------------
SELECT "Testing for no-parentheses natural matches" AS "";

INSERT INTO data_has_nhp_product( uid, nhp_id, type )
SELECT DISTINCT uid, nhp_id, "no-parens"
FROM data
JOIN natural_name ON data.id_name_sp_no_parens = natural_name.name_no_parens
WHERE uid NOT IN (
  SELECT DISTINCT uid FROM data_has_dp_product UNION SELECT DISTINCT uid FROM data_has_nhp_product
);

SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

-- ------------------------------------------------------------------------------------------------
SELECT "Testing for no-units drug matches" AS "";

INSERT INTO data_has_dp_product( uid, dp_id, type )
SELECT DISTINCT uid, dp_id, "no-units"
FROM data
JOIN drug_name ON data.id_name_sp_no_units = drug_name.name_no_units
WHERE uid NOT IN (
  SELECT DISTINCT uid FROM data_has_dp_product UNION SELECT DISTINCT uid FROM data_has_nhp_product
);

SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

-- ------------------------------------------------------------------------------------------------
SELECT "Testing for no-units natural matches" AS "";

INSERT INTO data_has_nhp_product( uid, nhp_id, type )
SELECT DISTINCT uid, nhp_id, "no-units"
FROM data
JOIN natural_name ON data.id_name_sp_no_units = natural_name.name_no_units
WHERE uid NOT IN (
  SELECT DISTINCT uid FROM data_has_dp_product UNION SELECT DISTINCT uid FROM data_has_nhp_product
);

SELECT CONCAT( ROW_COUNT(), " matches found" ) AS "";

-- ------------------------------------------------------------------------------------------------
SELECT "Removing data that has more than 5 matches" AS "";

DELETE FROM data_has_dp_product
WHERE uid IN ( SELECT uid FROM ( SELECT uid FROM data_has_dp_product GROUP BY uid HAVING COUNT(*) > 5 ) AS temp );

SELECT CONCAT( ROW_COUNT(), " drug matches removed" ) AS "";

DELETE FROM data_has_nhp_product
WHERE uid IN ( SELECT uid FROM ( SELECT uid FROM data_has_nhp_product GROUP BY uid HAVING COUNT(*) > 5 ) AS temp );

SELECT CONCAT( ROW_COUNT(), " natural matches removed" ) AS "";

-- ------------------------------------------------------------------------------------------------
SELECT "Replacing multiple matches with lowest ranking DIN or NPN" AS "";

ALTER TABLE data_has_dp_product
ADD COLUMN first TINYINT(1) DEFAULT 0;

DROP TABLE IF EXISTS first_din;
CREATE TEMPORARY TABLE first_din
SELECT DISTINCT uid, MIN( din ) AS din
FROM data_has_dp_product
JOIN dp_product ON dp_id = dp_product.id AND dp_product.din IS NOT NULL
GROUP BY uid;
ALTER TABLE first_din ADD INDEX dk_din( din );

UPDATE data_has_dp_product
JOIN first_din USING( uid )
JOIN dp_product ON data_has_dp_product.dp_id = dp_product.id
               AND first_din.din = dp_product.din
SET first = 1;

DELETE FROM data_has_dp_product WHERE first = 0;
ALTER TABLE data_has_dp_product DROP COLUMN first;

ALTER TABLE data_has_nhp_product
ADD COLUMN first TINYINT(1) DEFAULT 0;

CREATE TEMPORARY TABLE first_npn
SELECT DISTINCT uid, MIN( npn ) AS npn
FROM data_has_nhp_product
JOIN nhp_product ON nhp_id = nhp_product.id AND nhp_product.npn IS NOT NULL
GROUP BY uid;
ALTER TABLE first_npn ADD INDEX dk_npn( npn );

UPDATE data_has_nhp_product
JOIN first_npn USING( uid )
JOIN nhp_product ON data_has_nhp_product.nhp_id = nhp_product.id
               AND first_npn.npn = nhp_product.npn
SET first = 1;

DELETE FROM data_has_nhp_product WHERE first = 0;
ALTER TABLE data_has_nhp_product DROP COLUMN first;
