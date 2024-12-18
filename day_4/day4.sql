WITH previous AS (
    SELECT
        toy_id,
        UNNEST(previous_tags) AS prior_tags
    FROM toy_production
),
current AS (
    SELECT
        toy_id,
        UNNEST(new_tags) AS new_tags
    FROM toy_production
),
data_merge AS (
    SELECT
        COALESCE(previous.toy_id, current.toy_id) AS toy_id,
        CASE WHEN current.new_tags IS NULL THEN previous.prior_tags END AS removed_tags,
        CASE WHEN previous.prior_tags IS NULL THEN current.new_tags END AS added_tags,
        CASE WHEN current.new_tags IS NOT NULL AND previous.prior_tags IS NOT NULL THEN current.new_tags END AS unchanged_tags
    FROM previous
    FULL OUTER JOIN current ON previous.toy_id = current.toy_id AND prior_tags = new_tags
),
answer AS (
    SELECT
        toy_id,
        array_remove(array_agg(removed_tags), NULL) AS removed_tags,
        array_remove(array_agg(added_tags), NULL) AS added_tags,
        array_remove(array_agg(unchanged_tags), NULL) AS unchanged_tags
    FROM data_merge
    GROUP BY 1
    HAVING array_length(array_remove(array_agg(added_tags), NULL), 1) IS NOT NULL
    ORDER BY array_length(array_remove(array_agg(added_tags), NULL), 1) DESC
    LIMIT 1
)

SELECT
    toy_id,
    array_length(added_tags, 1),
    array_length(unchanged_tags, 1),
    array_length(removed_tags, 1)
FROM answer;