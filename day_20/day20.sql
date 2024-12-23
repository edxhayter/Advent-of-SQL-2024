WITH parse AS(
  SELECT 
    request_id,
    url,
    substring(url FROM '\?(.*)$') AS parameter
  FROM web_requests
  WHERE substring(url FROM '\?(.*)$') LIKE '%utm_source=advent-of-sql%'
),
flatten AS (
  SELECT
  	url,
  	-- previously tried to be quick and dirty and count '&' occurences + 1
  	-- realised the challenge wants us to count distinct parameter 'KEYS'
  	-- so unnest the array and take the key from the key value pair and count distinct it.
  	split_part(unnest(string_to_array(parameter, '&')), '=', 1) AS parameter_key
  FROM parse
)
-- SELECT * FROM flatten;
SELECT 
  url,
  COUNT(DISTINCT parameter_key) AS unique_count
FROM flatten
GROUP BY 1
ORDER BY 2 DESC, 1 ASC
LIMIT 1;