**Schema (PostgreSQL v17)**

    DROP TABLE IF EXISTS letters_a CASCADE;
    DROP TABLE IF EXISTS letters_b CASCADE;
    
    CREATE TABLE letters_a (
      id SERIAL PRIMARY KEY,
      value INTEGER
    );
    
    CREATE TABLE letters_b (
      id SERIAL PRIMARY KEY,
      value INTEGER
    );
    
    INSERT INTO letters_a (id, value) VALUES
    (1, 125),
    (2, 38),
    (3, 123),
    (4, 36),
    (5, 94),
    ETC...;
    
    INSERT INTO letters_b (id, value) VALUES
    (1, 62),
    (2, 38),
    (3, 62),
    (4, 60),
    (5, 94),
    ETC...;
    

---

**Query #1**

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

| msg                                                                                                 |
| --------------------------------------------------------------------------------------------------- |
| Dear Santa, I hope this letter finds you well in the North Pole! I want a SQL course for Christmas! |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/7APs2BhEYvFSLWQtnKBdcC/3)