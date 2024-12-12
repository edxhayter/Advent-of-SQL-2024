**Schema (PostgreSQL v17)**

    DROP TABLE IF EXISTS toy_production CASCADE;
    
    CREATE TABLE toy_production (
        production_date DATE PRIMARY KEY,
        toys_produced INTEGER
    );
    
    INSERT INTO toy_production (production_date, toys_produced) VALUES
    ('2024-11-30', 8469),
    ('2024-11-29', 2245),
    ('2024-11-28', 1621),
    ('2024-11-27', 630),
    ETC...;
    

---

**Query #1**

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

| production_date |
| --------------- |
| 2017-03-20      |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/9y6s1rxskHXZQNytynEpY5/2)