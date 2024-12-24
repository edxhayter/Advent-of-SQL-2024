**Schema (PostgreSQL v17)**

    DROP TABLE IF EXISTS elves CASCADE;
    CREATE TABLE elves (
      id SERIAL PRIMARY KEY,
      elf_name VARCHAR(255) NOT NULL,
      skills TEXT NOT NULL
    );
    
    INSERT INTO elves (elf_name, skills)
    VALUES
    ('Aethien', 'MYSQL,Perl,Kotlin,SQL,Elixir,Java,C++,Haskell'),
    ('Lunor', 'Haskell,SQL-Lite,Go,Scala,Kotlin,SQL'),
    ('Lulor', 'Rust,Swift,PHP,Java,C#,C++,JavaScript'),
    ('Dathien', 'C++,C#,Python,SQLSERVER'),
    ('Iriwen', 'Ruby'),
		ETC...
    ('Dawen', 'Java,C++,SQL');
    

---

**Query #1**

    SELECT 
    	COUNT(DISTINCT elves.id)
    FROM elves
    INNER JOIN (SELECT
                	id,
                	UNNEST(STRING_TO_ARRAY(skills, ',')) AS skill
                	FROM elves
                ) sq ON elves.id = sq.id
    WHERE skill = 'SQL';

| count |
| ----- |
| 2488  |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/h1MoFJqB4QXdEsmrWguNoh/1)