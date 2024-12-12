# Day 1

**Schema (PostgreSQL v17)**

    DROP TABLE IF EXISTS children CASCADE;
    DROP TABLE IF EXISTS wish_lists CASCADE;
    DROP TABLE IF EXISTS toy_catalogue CASCADE;
    
    CREATE TABLE children (
      child_id INT PRIMARY KEY,
      name VARCHAR(100),
      age INT
    );
    CREATE TABLE wish_lists (
        list_id INT PRIMARY KEY,
        child_id INT,
        wishes JSON,
        submitted_date DATE
    );
    CREATE TABLE toy_catalogue (
        toy_id INT PRIMARY KEY,
        toy_name VARCHAR(100),
        category VARCHAR(50),
        difficulty_to_make INT
    );
    
    INSERT INTO children VALUES
    (1, 'Elinor', 10),
    (2, 'Yoshiko', 9),
    (3, 'Alta', 14),
    (4, 'Evalyn', 5),
    (5, 'Sim', 10),
    ETC...;
    
    INSERT INTO wish_lists VALUES
    (1, 160, '{"colors":["White","Brown","Blue"],"first_choice":"Toy kitchen sets","second_choice":"Barbie dolls"}', '2024-05-11'),
    (2, 97, '{"colors":["Orange"],"first_choice":"LEGO blocks","second_choice":"Building sets"}', '2024-02-05'),
    (3, 548, '{"colors":["Brown","Purple","White","Yellow","Purple"],"first_choice":"LEGO blocks","second_choice":"Toy trains"}', '2024-06-18'),
    (4, 978, '{"colors":["Red","Purple"],"first_choice":"Building sets","second_choice":"Rubiks cubes"}', '2024-03-10'),
    (5, 983, '{"colors":["Yellow","Blue"],"first_choice":"Toy trucks","second_choice":"Stuffed animals"}', '2024-10-13'),
    ETC...;
    
    INSERT INTO toy_catalogue VALUES
    (1, 'LEGO blocks', 'educational', 3),
    (2, 'Teddy bears', 'indoor', 4),
    (3, 'Dollhouses', 'indoor', 5),
    (4, 'Remote control cars', 'indoor_outdoor', 4),
    (5, 'Action figures', 'indoor', 3),
    ETC...;
    

---

**Query #1**

    WITH wishes_unnested AS (
      SELECT 
    	wish_lists.child_id,
       	wishes::json->'first_choice' AS primary_wish,
        wishes::json->'second_choice' AS backup_wish,
      	wishes::json#>'{colors, 0}' AS favorite_color,
        wishes::json->'colors' AS colors
      FROM wish_lists
    ),
    clean_wishes AS (
      SELECT
      	child_id,
      	REPLACE(primary_wish::varchar, '"', '') AS primary_wish,
        REPLACE(backup_wish::varchar, '"', '') AS backup_wish,
        REPLACE(favorite_color::varchar, '"', '') AS favorite_color,
        LENGTH(colors::varchar) -  LENGTH(REPLACE(colors::varchar, ',', '')) + 1 AS color_count 
       
      FROM wishes_unnested
     ),
    data_merge AS (
     SELECT 
    	children.name,
        clean_wishes.*,
        toy_catalogue.category,
        toy_catalogue.difficulty_to_make
        
    FROM clean_wishes
    LEFT JOIN children ON children.child_id = clean_wishes.child_id
    LEFT JOIN toy_catalogue ON clean_wishes.primary_wish = toy_catalogue.toy_name
    )
    
    SELECT
    	name,
        primary_wish,
        backup_wish,
        favorite_color,
        color_count,
        CASE
        	WHEN difficulty_to_make >= 3 THEN 'Complex Gift'
            WHEN difficulty_to_make = 2 THEN 'Moderate Gift'
            WHEN difficulty_to_make = 1 THEN 'Simple Gift'
        END AS gift_complexity,
        CASE
        	WHEN category = 'outdoor' THEN 'Outside Workshop'
            WHEN category = 'educational' THEN 'Learning Workshop'
            ELSE 'General Workshop'
        END AS workshop_assignment
    FROM data_merge
    ORDER BY name ASC
    LIMIT 5;

| name    | primary_wish    | backup_wish     | favorite_color | color_count | gift_complexity | workshop_assignment |
| ------- | --------------- | --------------- | -------------- | ----------- | --------------- | ------------------- |
| Abagail | Building sets   | LEGO blocks     | Blue           | 1           | Complex Gift    | Learning Workshop   |
| Abbey   | Stuffed animals | Teddy bears     | White          | 4           | Complex Gift    | General Workshop    |
| Abbey   | Barbie dolls    | Play-Doh        | Purple         | 1           | Moderate Gift   | General Workshop    |
| Abbey   | Toy trains      | Toy trains      | Pink           | 2           | Complex Gift    | General Workshop    |
| Abbey   | Yo-yos          | Building blocks | Blue           | 5           | Simple Gift     | General Workshop    |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/8WVgob4sMV2iiymgPPmLg1/0)
