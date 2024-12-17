-- Dedupe for each skill and experience find the max 
WITH dedupe AS (
	SELECT
		primary_skill,
		years_experience,
		min(elf_id) AS elf_id
	FROM public.workshop_elves
	GROUP BY 1, 2

),

-- identify the max and min experience for each skill
pairings AS (
  
  SELECT 
  	primary_skill,
  	max(years_experience) AS max_exp,
  	min(years_experience) AS min_exp
 FROM workshop_elves
 GROUP BY 1
 )
  
 -- join to subset the data and then dedupe based on elved ID
  
 SELECT
  	max_join.elf_id AS elf_1_id,
  	min_join.elf_id AS elf_2_id,
	pairings.primary_skill
 FROM pairings
LEFT JOIN dedupe AS max_join ON pairings.primary_skill = max_join.primary_skill 
  AND pairings.max_exp = max_join.years_experience 
 LEFT JOIN dedupe AS min_join ON pairings.primary_skill = min_join.primary_skill 
  AND pairings.min_exp = min_join.years_experience 
ORDER BY pairings.primary_skill
;
 