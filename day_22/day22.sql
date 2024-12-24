SELECT 
	COUNT(DISTINCT elves.id)
FROM elves
INNER JOIN (SELECT
            	id,
            	UNNEST(STRING_TO_ARRAY(skills, ',')) AS skill
            	FROM elves
            ) sq ON elves.id = sq.id
WHERE skill = 'SQL';