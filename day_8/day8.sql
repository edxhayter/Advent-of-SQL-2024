WITH RECURSIVE recursive_cte AS (
    -- initial query
    SELECT 
        staff_id,
        staff_name,
        manager_id,
        1 AS level,
        CAST(staff_id AS VARCHAR) AS path
    FROM staff
    WHERE manager_id IS NULL

    UNION ALL
    
    SELECT
        staff.staff_id,
        staff.staff_name,
        staff.manager_id,
        recursive_cte.level + 1,
        recursive_cte.path || ',' || staff.staff_id

    FROM staff
    INNER JOIN recursive_cte
        ON staff.manager_id = recursive_cte.staff_id
)
SELECT * from recursive_cte
ORDER BY LEVEL DESC, path
LIMIT 1;
