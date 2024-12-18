WITH agg AS (
    SELECT
        gift_id,
        count(request_id) AS cnt,
        round(percent_rank() OVER (ORDER BY count(request_id))::numeric, 2) AS percentile
    FROM gift_requests
    GROUP BY 1
)

SELECT
    gifts.gift_name,
    percentile
FROM agg
    LEFT JOIN gifts ON agg.gift_id = gifts.gift_id
WHERE agg.cnt <> (SELECT MAX(agg.cnt) FROM agg) 
ORDER BY percentile DESC, gift_name ASC
LIMIT 1;