WITH average_last_score AS (
  SELECT
    AVG(year_end_performance_scores[array_length(year_end_performance_scores, 1)]) AS avg_last_score
  FROM employees
),

data_merge AS (
 SELECT
 	employee_id,
    name,
    salary,
  	CASE
  		WHEN year_end_performance_scores[array_length(year_end_performance_scores, 1)] > avg_last_score
        THEN 0.15*salary
        ELSE 0
    END AS bonus
 FROM employees
 INNER JOIN average_last_score ON 1=1
) 
SELECT 
round(SUM(salary + bonus), 2)
FROM data_merge;
