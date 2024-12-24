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