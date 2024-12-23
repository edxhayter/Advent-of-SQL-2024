WITH quarter_agg AS (
  SELECT
  	EXTRACT(year FROM sale_date) AS year,
  	EXTRACT(quarter FROM sale_date) AS quarter,
  	SUM(amount) AS total_sales
  FROM sales
  GROUP BY 1, 2
),
growth_rate AS (
SELECT 
	*,
  -- coalesce required otherwise limit 1 takes the NULL growth value
    COALESCE((total_sales - LAG(total_sales, 1) OVER (ORDER BY year ASC, quarter ASC))/LAG(total_sales, 1) OVER (ORDER BY year ASC, quarter ASC), 0) AS growth_rate
FROM quarter_agg
ORDER BY growth_rate DESC
 LIMIT 1
)

SELECT year, quarter, growth_rate FROM growth_rate;
	
