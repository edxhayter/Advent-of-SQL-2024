WITH import AS(
    SELECT
        id,
        name,
        UNNEST(email_addresses)::varchar AS address
    FROM contact_list
)
SELECT 
    regexp_substr(address, '.*@(.*)', 1, 1, 'i', 1) AS domain,
    count(*) AS total_users,
    array_agg(address) AS users
FROM import
GROUP BY 1
ORDER BY total_users DESC
LIMIT 1
;