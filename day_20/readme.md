**Schema (PostgreSQL v17)**

    DROP TABLE IF EXISTS web_requests CASCADE;
    CREATE TABLE web_requests (
      request_id SERIAL PRIMARY KEY,
      url TEXT NOT NULL
    );
    
    INSERT INTO web_requests (url) VALUES
    ('http://graham.biz?est_rerum_corrupti_fuga=et-ut-quia-repudiandae&utm_source=sit-exercitationem&labore-error-perferendis-dicta=voluptas_molestias_laudantium&sunt_et_vel_incidunt_earum=mollitia_aut_distinctio'),
    ('http://auer.org?utm_source=et-ut&utm_source=advent-of-sql&utm_source=advent-of-sql&utm_source=advent-of-sql'),
    ('https://walter.org?tenetur-nulla-repellendus-debitis-sit=iste-est-veritatis&velit_autem_atque_quisquam_corporis=voluptates-distinctio-est-et-nam&utm_source=aut_magni_inventore&utm_source=advent-of-sql'),
    ('http://quigley.org?utm_source=in-quia-mollitia-assumenda&utm_source=advent-of-sql&utm_source=ut_ex_et_quidem&harum-ut-suscipit-quia=eum_deserunt'),
		ETC...
    ('http://bradtke.name?utm_source=vel_assumenda&facilis_corrupti_aut_velit_sed=iure-eligendi&possimus-vero-et-consequatur=voluptas-est-qui-autem-qui&laborum-rerum-rerum-at=accusamus-blanditiis-natus')
    

---

**Query #1**

    WITH parse AS(
      SELECT 
        request_id,
        url,
        substring(url FROM '\?(.*)$') AS parameter
      FROM web_requests
      WHERE substring(url FROM '\?(.*)$') LIKE '%utm_source=advent-of-sql%'
    ),
    flatten AS (
      SELECT
      	url,
      	-- previously tried to be quick and dirty and count '&' occurences + 1
      	-- realised the challenge wants us to count distinct parameter 'KEYS'
      	-- so unnest the array and take the key from the key value pair and count distinct it.
      	split_part(unnest(string_to_array(parameter, '&')), '=', 1) AS parameter_key
      FROM parse
    )
    -- SELECT * FROM flatten;
    SELECT 
      url,
      COUNT(DISTINCT parameter_key) AS unique_count
    FROM flatten
    GROUP BY 1
    ORDER BY 2 DESC, 1 ASC
    LIMIT 1;

| url                                                                                                                                                                                                         | unique_count |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------ |
| http://abbott.biz?sapiente_incidunt_quisquam_saepe=tempore-vel-labore-vel&eos-fugit-veniam-alias=voluptatum_officia_esse_ut_numquam&ea_voluptas=possimus-iure-doloribus-ab-dolorum&utm_source=advent-of-sql | 4            |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/aGg7aPDL1sGwFAbweMZVbP/1)