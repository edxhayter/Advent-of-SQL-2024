**Schema (PostgreSQL v17)**

    DROP TABLE IF EXISTS users CASCADE;
    DROP TABLE IF EXISTS songs CASCADE;
    DROP TABLE IF EXISTS user_plays CASCADE;
    
    CREATE TABLE users (
        user_id INT PRIMARY KEY,
        username VARCHAR(255) NOT NULL
    );
    CREATE TABLE songs (
        song_id INT PRIMARY KEY,
        song_title VARCHAR(255) NOT NULL,
        song_duration INT  -- Duration in seconds, can be NULL if unknown
    );
    CREATE TABLE user_plays (
        play_id INT PRIMARY KEY,
        user_id INT,
        song_id INT,
        play_time DATE,
        duration INT,  -- Duration in seconds, can be NULL
        FOREIGN KEY (user_id) REFERENCES users(user_id),
        FOREIGN KEY (song_id) REFERENCES songs(song_id)
    );
    
    INSERT INTO users (user_id, username) VALUES
    (1, 'Lenora Alejandra'),
    (2, 'Carmen Martina'),
    (3, 'Colt Judge'),
    (4, 'Mittie Kennith'),
    (5, 'Berneice Hunter'),
		ETC...
    (100, 'Brice Bettye');
    
    
    INSERT INTO songs (song_id, song_title, song_duration) VALUES
    (1, 'All I Want For Christmas Is You', 241),
    (2, 'Last Christmas', 262),
    (3, 'Jingle Bells', 155),
    (4, 'Silent Night', 180),
    (5, 'Rudolph the Red-Nosed Reindeer', 150),
    (6, 'White Christmas', 185),
    (7, 'Santa Claus Is Coming to Town', 204),
    (8, 'Let It Snow! Let It Snow! Let It Snow!', 158),
    (9, 'The Christmas Song (Merry Christmas to You)', NULL),
    (10, 'Feliz Navidad', 183),
    (11, 'Have Yourself a Merry Little Christmas', 225),
    (12, 'Winter Wonderland', 141),
    (13, 'Deck the Halls', 120),
    (14, 'O Holy Night', 285),
    (15, 'Frosty the Snowman', 159),
    (16, 'Its Beginning to Look a Lot Like Christmas', NULL),
    (17, 'Silver Bells', 189),
    (18, 'The First Noel', 197),
    (19, 'Joy to the World', 135),
    (20, 'O Come, All Ye Faithful', 201);
    
    
    INSERT INTO user_plays (play_id, user_id, song_id, play_time, duration) VALUES
    (1, 79, 20, '2024-12-10 3:17:17', 89),
    (2, 85, 12, '2024-12-16 13:8:9', 98),
    (3, 46, 1, '2024-12-15 21:14:24', 47),
    (4, 69, 11, '2024-12-22 17:17:22', 20),
    (5, 13, 15, '2024-12-5 1:1:42', NULL),
		ETC...
    (10000, 67, 15, '2024-12-8 20:43:53', 63);
    
    

---

**Query #1**

    WITH song_stats AS (
      SELECT
      	user_plays.song_id,
      	songs.song_title,
      	COUNT(DISTINCT CASE WHEN duration < song_duration THEN play_id END) AS skips,
      	COUNT(DISTINCT CASE WHEN duration = song_duration THEN play_id END) AS total_plays
      FROM user_plays
      LEFT JOIN songs ON user_plays.song_id = songs.song_id
      WHERE song_duration IS NOT NULL
      GROUP BY 1, 2
    )
    
    SELECT 
    	song_title,
        total_plays,
        skips
    FROM song_stats
    ORDER BY total_plays DESC, skips ASC;

| song_title                             | total_plays | skips |
| -------------------------------------- | ----------- | ----- |
| All I Want For Christmas Is You        | 118         | 412   |
| Frosty the Snowman                     | 107         | 352   |
| Winter Wonderland                      | 104         | 386   |
| Jingle Bells                           | 103         | 399   |
| Let It Snow! Let It Snow! Let It Snow! | 100         | 381   |
| Silver Bells                           | 99          | 386   |
| Silent Night                           | 99          | 389   |
| Rudolph the Red-Nosed Reindeer         | 97          | 370   |
| The First Noel                         | 97          | 416   |
| White Christmas                        | 96          | 382   |
| O Holy Night                           | 94          | 351   |
| Deck the Halls                         | 94          | 395   |
| Joy to the World                       | 92          | 347   |
| Have Yourself a Merry Little Christmas | 91          | 359   |
| O Come, All Ye Faithful                | 91          | 378   |
| Feliz Navidad                          | 89          | 355   |
| Santa Claus Is Coming to Town          | 87          | 376   |
| Last Christmas                         | 86          | 385   |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/eb8VonpBjrcnNEhRi5enMw/0)