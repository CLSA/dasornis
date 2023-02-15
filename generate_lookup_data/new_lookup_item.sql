SELECT "Creating new_lookup_item table" AS "";

DROP TABLE IF EXISTS new_lookup_item;
CREATE TABLE new_lookup_item (
  id INT NOT NULL AUTO_INCREMENT,
  identifier VARCHAR(45) NOT NULL,
  status ENUM('approved', 'marketed', 'cancelled', 'dormant'),
  name VARCHAR(255) NOT NULL,
  description TEXT NULL DEFAULT NULL,
  atc_number VARCHAR(20) NULL DEFAULT NULL,
  atc VARCHAR(120) NULL DEFAULT NULL,
  PRIMARY KEY (id),
  INDEX dk_identifier (identifier),
  UNIQUE KEY uq_identifier (identifier)
) ENGINE=InnoDB CHARSET=utf8;

INSERT INTO new_lookup_item( identifier, status, name, description, atc_number, atc )
SELECT
  din,
  status,
  brand_name,
  CONCAT(
    brand_name,
    " (",
    GROUP_CONCAT(
      ingredient,
      " ",
      strength,
      strength_unit
      ORDER BY code
      SEPARATOR ", "
    ),
    ")"
  ) AS description,
  GROUP_CONCAT( atc_number ORDER BY atc_number SEPARATOR ";" ) AS atc_number,
  GROUP_CONCAT( atc ORDER BY atc SEPARATOR ";" ) AS atc
FROM dp_product
LEFT JOIN dp_active_ingredient ON dp_product.id = dp_active_ingredient.dp_id
LEFT JOIN dp_therapeutic_class ON dp_product.id = dp_therapeutic_class.dp_id
WHERE dp_product.class = "Human"
GROUP BY din
ORDER BY din;
