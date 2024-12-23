**Schema (PostgreSQL v17)**

    DROP TABLE IF EXISTS sales CASCADE;
    CREATE TABLE sales (
      id SERIAL PRIMARY KEY,
      sale_date DATE NOT NULL,
      amount DECIMAL(10, 2) NOT NULL
    );
    
    INSERT INTO sales (sale_date, amount) VALUES
    ('2024-12-19', 2058.00),
    ('2024-12-18', 203.00),
    ('2024-12-17', 9225.00),
    ('2024-12-16', 6603.00),
    ('2024-12-15', 6259.00),
    ('2024-12-14', 9443.00),
    ('2024-12-13', 3211.00),
    ('2024-12-12', 5711.00),
		ETC...
    ('1997-08-04', 5907.00);
    
    

---

**Query #1**

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

| year | quarter | growth_rate            |
| ---- | ------- | ---------------------- |
| 1997 | 4       | 0.39570145652886235324 |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/acyBdGCxX542REWzncT9Kn/3)