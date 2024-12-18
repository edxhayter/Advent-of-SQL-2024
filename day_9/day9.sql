WITH avg_speeds AS (

    SELECT

        reindeers.reindeer_name,
        training_sessions.exercise_name,

        avg(speed_record) AS avg_speed

    FROM training_sessions
    INNER JOIN reindeers ON training_sessions.reindeer_id = reindeers.reindeer_id
    GROUP BY 1, 2

),

ranked AS (
SELECT

    reindeer_name,
    avg_speed,
    rank() OVER (PARTITION BY reindeer_name ORDER BY avg_speed DESC) AS ranking

FROM avg_speeds
)

SELECT

    reindeer_name,
    round(avg_speed, 2) AS highest_average_score

FROM ranked
WHERE ranking = 1
ORDER BY highest_average_score DESC
LIMIT 3
;