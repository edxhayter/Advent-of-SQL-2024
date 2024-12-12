WITH wishes_unnested AS (
  SELECT 
	wish_lists.child_id,
   	wishes::json->'first_choice' AS primary_wish,
    wishes::json->'second_choice' AS backup_wish,
  	wishes::json#>'{colors, 0}' AS favorite_color,
    wishes::json->'colors' AS colors
  FROM wish_lists
),
clean_wishes AS (
  SELECT
  	child_id,
  	REPLACE(primary_wish::varchar, '"', '') AS primary_wish,
    REPLACE(backup_wish::varchar, '"', '') AS backup_wish,
    REPLACE(favorite_color::varchar, '"', '') AS favorite_color,
    LENGTH(colors::varchar) -  LENGTH(REPLACE(colors::varchar, ',', '')) + 1 AS color_count 
   
  FROM wishes_unnested
 ),
data_merge AS (
 SELECT 
	children.name,
    clean_wishes.*,
    toy_catalogue.category,
    toy_catalogue.difficulty_to_make
    
FROM clean_wishes
LEFT JOIN children ON children.child_id = clean_wishes.child_id
LEFT JOIN toy_catalogue ON clean_wishes.primary_wish = toy_catalogue.toy_name
)

SELECT
	name,
    primary_wish,
    backup_wish,
    favorite_color,
    color_count,
    CASE
    	WHEN difficulty_to_make >= 3 THEN 'Complex Gift'
        WHEN difficulty_to_make = 2 THEN 'Moderate Gift'
        WHEN difficulty_to_make = 1 THEN 'Simple Gift'
    END AS gift_complexity,
    CASE
    	WHEN category = 'outdoor' THEN 'Outside Workshop'
        WHEN category = 'educational' THEN 'Learning Workshop'
        ELSE 'General Workshop'
    END AS workshop_assignment
FROM data_merge
ORDER BY name ASC
LIMIT 5;
