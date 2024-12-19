**Schema (PostgreSQL v17)**

    DROP TABLE IF EXISTS SantaRecords CASCADE;
    CREATE TABLE SantaRecords (
        record_id SERIAL PRIMARY KEY,
        record_date DATE NOT NULL,
        cleaning_receipts JSONB NOT NULL
    );
    
    INSERT INTO SantaRecords (record_id, record_date, cleaning_receipts) VALUES
    (1, '2024-12-10', '[
    {
            "receipt_id": "R839506",
            "garment": "robe",
            "color": "white",
            "cost": 26.47,
            "drop_off": "2024-12-10",
            "pickup": "2024-12-13"
        },
        {
            "receipt_id": "R925463",
            "garment": "boots",
            "color": "brown",
            "cost": 47.79,
            "drop_off": "2024-12-10",
            "pickup": "2024-12-13"
        },
        {
            "receipt_id": "R825459",
            "garment": "mittens",
            "color": "silver",
            "cost": 16.86,
            "drop_off": "2024-12-10",
            "pickup": "2024-12-14"
        },
        {
            "receipt_id": "R577987",
            "garment": "sweater",
            "color": "white",
            "cost": 49.12,
            "drop_off": "2024-12-10",
            "pickup": "2024-12-13"
        },
        {
            "receipt_id": "R217032",
            "garment": "boots",
            "color": "red",
            "cost": 38.62,
            "drop_off": "2024-12-10",
            "pickup": "2024-12-14"
        }
    ]');
    
    
    INSERT INTO SantaRecords (record_id, record_date, cleaning_receipts) VALUES
    (2, '2024-12-15', '[
    {
            "receipt_id": "R977585",
            "garment": "mittens",
            "color": "black",
            "cost": 39.83,
            "drop_off": "2024-12-15",
            "pickup": "2024-12-19"
        },
        {
            "receipt_id": "R49658",
            "garment": "sweater",
            "color": "maroon",
            "cost": 37.47,
            "drop_off": "2024-12-15",
            "pickup": "2024-12-17"
        },
        {
            "receipt_id": "R813233",
            "garment": "hat",
            "color": "brown",
            "cost": 13.33,
            "drop_off": "2024-12-15",
            "pickup": "2024-12-17"
        },
        {
            "receipt_id": "R884116",
            "garment": "vest",
            "color": "white",
            "cost": 12.6,
            "drop_off": "2024-12-15",
            "pickup": "2024-12-18"
        },
        {
            "receipt_id": "R115734",
            "garment": "mittens",
            "color": "red",
            "cost": 25.12,
            "drop_off": "2024-12-15",
            "pickup": "2024-12-19"
        },
        {
            "receipt_id": "R177690",
            "garment": "pants",
            "color": "gold",
            "cost": 11.9,
            "drop_off": "2024-12-15",
            "pickup": "2024-12-17"
        },
        {
            "receipt_id": "R317326",
            "garment": "pants",
            "color": "silver",
            "cost": 48.34,
            "drop_off": "2024-12-15",
            "pickup": "2024-12-18"
        },
        {
            "receipt_id": "R556783",
            "garment": "hat",
            "color": "purple",
            "cost": 16.24,
            "drop_off": "2024-12-15",
            "pickup": "2024-12-19"
        }
    ]');

    ETC...
    
    INSERT INTO SantaRecords (record_id, record_date, cleaning_receipts) VALUES
    (120, '2024-12-20', '[
    {
            "receipt_id": "R289574",
            "garment": "pants",
            "color": "maroon",
            "cost": 48.32,
            "drop_off": "2024-12-20",
            "pickup": "2024-12-23"
        },
        {
            "receipt_id": "R587076",
            "garment": "mittens",
            "color": "silver",
            "cost": 30.72,
            "drop_off": "2024-12-20",
            "pickup": "2024-12-24"
        },
        {
            "receipt_id": "R376688",
            "garment": "vest",
            "color": "black",
            "cost": 11.61,
            "drop_off": "2024-12-20",
            "pickup": "2024-12-24"
        },
        {
            "receipt_id": "R398811",
            "garment": "coat",
            "color": "black",
            "cost": 34.51,
            "drop_off": "2024-12-20",
            "pickup": "2024-12-23"
        },
        {
            "receipt_id": "R132743",
            "garment": "suit",
            "color": "maroon",
            "cost": 22.01,
            "drop_off": "2024-12-20",
            "pickup": "2024-12-23"
        },
        {
            "receipt_id": "R350642",
            "garment": "boots",
            "color": "purple",
            "cost": 22.92,
            "drop_off": "2024-12-20",
            "pickup": "2024-12-22"
        },
        {
            "receipt_id": "R947045",
            "garment": "mittens",
            "color": "maroon",
            "cost": 35.58,
            "drop_off": "2024-12-20",
            "pickup": "2024-12-24"
        }
    ]');
    
    

---

**Query #1**

    -- Structure is an array of JSON
    WITH flatten AS (
    SELECT 
      record_id,
      record_date,
      jsonb_array_elements(cleaning_receipts) AS flattened
    FROM santarecords
    )
    
    SELECT 
    	jsonb_extract_path_text(flattened, 'drop_off')::date AS drop_off_dt
    FROM flatten
    WHERE jsonb_extract_path_text(flattened, 'color') = 'green'
    AND jsonb_extract_path_text(flattened, 'garment') = 'suit'
    ORDER BY drop_off_dt DESC
    LIMIT 1;

| drop_off_dt |
| ----------- |
| 2024-12-22  |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/57bmEmTsko6RvNoo6zH7f2/4)