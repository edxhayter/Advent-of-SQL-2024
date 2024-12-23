**Schema (PostgreSQL v17)**

    DROP TABLE IF EXISTS employees CASCADE;
    CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    salary DECIMAL(10, 2) NOT NULL,
    year_end_performance_scores INTEGER[] NOT NULL
    );
    
    INSERT INTO employees (name, salary, year_end_performance_scores) VALUES
    ('General', 564894, ARRAY[30,34,84,91,5]),
    ('Florida', 917555, ARRAY[4,27,55,29,6]),
    ('Mia', 272731, ARRAY[36,82,94,59,81]),
    ('Claudie', 705020, ARRAY[88,1,63,65,73]),
		ETC...
    ('Albina', 745197, ARRAY[36,63,56,83,81]);
    
    

---

**Query #1**

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

| round         |
| ------------- |
| 5491552488.10 |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/pSzZtD5rPdf8E12BUnUQBK/3)