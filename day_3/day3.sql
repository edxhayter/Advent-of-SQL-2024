-- XML parsing different structures so first pull the 3 different tags in a CTE
WITH structures AS (
    SELECT
    *,
    (xpath('name(/*)', menu_data))[1]::text AS root_tag_name
    FROM christmas_menus
),
-- christmas_feast, northpole_database, polar_celebration are the 3 structures
parse_xml AS (
SELECT
    CASE
        WHEN root_tag_name = 'polar_celebration'
        THEN (xpath('/polar_celebration/event_administration/participant_metrics/attendance_details/headcount/total_present/text()', menu_data))[1]::text
        WHEN root_tag_name = 'christmas_feast'
        THEN (xpath('/christmas_feast/organizational_details/attendance_record/total_guests/text()', menu_data))[1]::text
        WHEN root_tag_name = 'northpole_database'
        THEN (xpath('/northpole_database/annual_celebration/event_metadata/dinner_details/guest_registry/total_count/text()', menu_data))[1]::text
    END AS total_guests,
    CASE
        WHEN root_tag_name = 'polar_celebration'
        THEN xpath('/polar_celebration/event_administration/culinary_records/menu_analysis/item_performance/food_item_id/text()', menu_data)
        WHEN root_tag_name = 'christmas_feast'
        THEN xpath('/christmas_feast/organizational_details/menu_registry/course_details/dish_entry/food_item_id/text()', menu_data)
        WHEN root_tag_name = 'northpole_database'
        THEN xpath('/northpole_database/annual_celebration/event_metadata/menu_items/food_category/food_category/dish/food_item_id/text()', menu_data)
    END AS array_food
FROM structures
),
-- flatten the arrays (filtering to only the ones with enough guests)
flatten AS (
SELECT
    UNNEST(array_food) AS food_item,
    total_guests
FROM parse_xml
)
SELECT
    food_item::text,
    count(*) as freq
FROM flatten
WHERE CAST(total_guests AS numeric) > 78
GROUP BY 1
ORDER BY freq DESC
LIMIT 1;
