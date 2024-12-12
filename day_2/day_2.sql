-- Looks like UNICODE, we are provided a list of approved characters, check their unicode values and then filter. Then convert to unicode and list_agg() into a message

WITH union_data AS (
  SELECT
    id,
    value
  FROM letters_a
  UNION ALL
  SELECT
    id,
    value
  FROM letters_b
),

add_rn AS (
  SELECT
  *,
  row_number() OVER (ORDER BY NULL) AS rn
  FROM union_data
),
suppressed AS (
  SELECT
  	*
  FROM add_rn
  WHERE (value BETWEEN 32 AND 34) OR (value BETWEEN 39 AND 41)
  OR (value BETWEEN 44 AND 46) OR (value BETWEEN 58 AND 59)
  OR value = 63 OR (value BETWEEN 65 AND 90) OR (value BETWEEN 97 AND 122)
 ) 
SELECT REPLACE(string_agg(chr(value), '|' ORDER BY rn), '|', '') AS msg
FROM suppressed