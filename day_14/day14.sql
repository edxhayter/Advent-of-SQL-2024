-- Structure is an array of JSON
WITH flatten AS (
SELECT 
  record_id,
  record_date,
  jsonb_array_elements(cleaning_receipts) AS flattened
FROM santarecords
)

SELECT 
	jsonb_extract_path_text(flattened, 'drop_off')::date AS drop_off_dt
FROM flatten
WHERE jsonb_extract_path_text(flattened, 'color') = 'green'
AND jsonb_extract_path_text(flattened, 'garment') = 'suit'
ORDER BY drop_off_dt DESC
LIMIT 1;