**Schema (PostgreSQL v17)**

    DROP TABLE IF EXISTS children CASCADE;
    DROP TABLE IF EXISTS gifts CASCADE;
    
    CREATE TABLE children (
        child_id SERIAL PRIMARY KEY,
        name VARCHAR(100),
        age INTEGER,
        city VARCHAR(100)
    );
    
    CREATE TABLE gifts (
        gift_id SERIAL PRIMARY KEY,
        name VARCHAR(100),
        price DECIMAL(10,2),
        child_id INTEGER REFERENCES children(child_id)
    );
    
    INSERT INTO children (child_id, name, age, city) VALUES
    (1, 'Rodrick', 3, 'Heaney'),
    (2, 'Edgardo', 9, 'Frami'),
    (3, 'Oleta', 9, 'Lilyan'),
    (4, 'Bret', 15, 'South Cletus'),
    (5, 'Aleen', 11, 'East Danika'),
     ETC...;
    
    INSERT INTO gifts (gift_id, name, price, child_id) VALUES
    (1, 'learning tablet', 165.09, 236),
    (2, 'puzzle box', 683.28, 3371),
    (3, 'dinosaur figure', 120.29, 1618),
    (4, 'bowling set', 322.86, 1903),
    (5, 'scooter', 620.47, 298),
    ETC...;
    

---

**Query #1**

    SELECT
    	children.name,
        gifts.name,
        gifts.price
    FROM children
    LEFT JOIN gifts on children.child_id = gifts.child_id
    WHERE price > (SELECT avg(price) FROM gifts)
    ORDER BY 3 ASC
    LIMIT 1

| name   | name      | price  |
| ------ | --------- | ------ |
| Hobart | art easel | 497.44 |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/3S978WBfacPjsEHU8KHof1/0)