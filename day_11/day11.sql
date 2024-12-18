WITH import AS (
    SELECT 
    *,
    CASE
        WHEN season = 'Spring' THEN 1
        WHEN season = 'Summer' THEN 2
        WHEN season = 'Fall' THEN 3
        WHEN season = 'Winter' THEN 4
    END AS seq
    from treeharvests
)

SELECT
    field_name,
    harvest_year,
    season,
    ROUND(avg(trees_harvested) OVER (PARTITION BY field_name, harvest_year ORDER BY seq ASC ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2)AS three_season_moving_avg
FROM import
ORDER BY three_season_moving_avg DESC
LIMIT 1
;