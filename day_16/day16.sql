WITH journey_areas AS (
SELECT
  sleigh_locations.timestamp AS dt,
  areas.place_name,
  LEAD(sleigh_locations.timestamp) OVER (ORDER BY sleigh_locations.timestamp) AS next_dt,
  LEAD(areas.place_name) OVER (ORDER BY sleigh_locations.timestamp) AS next_place
FROM
    sleigh_locations
JOIN areas
ON ST_Contains(areas.polygon::geometry, sleigh_locations.coordinate::geometry)
),
duration AS (
  SELECT 
     place_name,
     dt,
     next_dt,
     CASE 
        WHEN next_place = place_name THEN next_dt
        WHEN next_place IS NULL THEN next_dt
        ELSE next_dt 
     END - dt AS duration
  FROM 
  journey_areas
)
SELECT 
    place_name,
    -- learnt about extracting epoch for precise time estimates
    ROUND(SUM(EXTRACT(EPOCH FROM duration))/3600, 2) AS total_hours_spent
FROM duration
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;