**Schema (PostgreSQL v17)**

    DROP TABLE IF EXISTS sequence_table CASCADE;
    CREATE TABLE sequence_table (
      id INT PRIMARY KEY
    );
    INSERT INTO sequence_table (id) VALUES
    ('114'),
    ('3801'),
    ('2757'),
    ('527'),
    ('3187'),
    ('7922'),
    ('3227'),
		ETC...
    ('4718');
    

---

**Query #1**

    WITH lead_values AS (
      SELECT 
          id,
          LEAD(id, 1) OVER (ORDER BY id ASC) AS lead_id
      FROM sequence_table
      ORDER BY 1 ASC
    ),
    scaffold_values AS (
      SELECT GENERATE_SERIES((SELECT MIN(id) FROM sequence_table),
                             (SELECT MAX(id) FROM sequence_table)) AS ints
    )
    
    SELECT 
    	id + 1 AS gap_start,
        lead_id - 1 AS gap_end,
        ARRAY_AGG(ints) AS missing_numbers
    FROM lead_values
    INNER JOIN scaffold_values ON
    	id < ints AND lead_id > ints
    WHERE lead_id <> id + 1
    GROUP BY 1, 2
    ORDER BY 1 ASC;

| gap_start | gap_end | missing_numbers            |
| --------- | ------- | -------------------------- |
| 997       | 1001    | {997,998,999,1000,1001}    |
| 3761      | 3765    | {3761,3762,3763,3764,3765} |
| 6525      | 6527    | {6525,6526,6527}           |
| 6529      | 6529    | {6529}                     |
| 9289      | 9292    | {9289,9290,9291,9292}      |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/4PhWPa92P1FRoG9ao6ouy/0)