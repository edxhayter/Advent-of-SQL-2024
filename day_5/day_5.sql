WITH report AS (
SELECT
	production_date,
    toys_produced,
    lag(toys_produced, 1, NULL) OVER (ORDER BY production_date asc) AS previous_day_production,
    toys_produced - lag(toys_produced, 1, NULL) OVER (ORDER BY production_date asc) AS production_change,
    ((toys_produced - lag(toys_produced, 1, NULL) OVER (ORDER BY production_date asc))/lag(toys_produced, 1, NULL) OVER (ORDER BY production_date asc))*100 AS production_change_percentage
FROM toy_production
ORDER BY production_date DESC
),
max_increase AS (
SELECT max(production_change_percentage) AS max_pct
FROM report
)

SELECT production_date
FROM report
INNER JOIN max_increase ON report.production_change_percentage = max_increase.max_pct;
