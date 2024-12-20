DROP TABLE IF EXISTS Workshops;
CREATE TABLE Workshops (
  workshop_id INT PRIMARY KEY,
  workshop_name VARCHAR(100),
  timezone VARCHAR(50),
  business_start_time TIME,
  business_end_time TIME
);

INSERT INTO Workshops (workshop_id, workshop_name, timezone, business_start_time, business_end_time) VALUES
(1, 'North Pole HQ', 'UTC', '09:00', '17:00'),
(3, 'Workshop 3', 'Europe/London', '09:00', '16:00'),
(4, 'Workshop 4', 'America/New_York', '09:30', '17:30'),
(7, 'Workshop 7', 'Africa/Johannesburg', '09:00', '19:00'),
(10, 'Workshop 10', 'Europe/Berlin', '09:00', '20:00'),
(20, 'Workshop 20', 'Europe/Zurich', '09:00', '17:30'),
(21, 'Workshop 21', 'Europe/Moscow', '08:30', '18:00'),
(22, 'Workshop 22', 'Europe/Helsinki', '09:00', '17:00'),
(23, 'Workshop 23', 'Europe/Dublin', '08:00', '16:30'),
(24, 'Workshop 24', 'Europe/Istanbul', '09:30', '18:00'),
(25, 'Workshop 25', 'Europe/Lisbon', '09:00', '17:30'),
(26, 'Workshop 26', 'Europe/Madrid', '08:30', '17:00'),
(27, 'Workshop 27', 'Europe/Vienna', '09:00', '18:30'),
(28, 'Workshop 28', 'Europe/Oslo', '08:00', '16:00'),
(29, 'Workshop 29', 'Europe/Prague', '09:00', '17:30'),
(30, 'Workshop 30', 'Europe/Rome', '08:30', '18:00'),
(31, 'Workshop 31', 'Europe/Amsterdam', '09:00', '17:00'),
(32, 'Workshop 32', 'Europe/Stockholm', '08:30', '16:30'),
(33, 'Workshop 33', 'Europe/Brussels', '09:00', '18:00'),
(34, 'Workshop 34', 'Europe/Warsaw', '08:00', '17:30'),
(35, 'Workshop 35', 'Europe/Paris', '09:00', '17:30'),
(36, 'Workshop 36', 'Europe/Luxembourg', '08:30', '17:00'),
(37, 'Workshop 37', 'Europe/Ljubljana', '09:00', '18:00'),
(38, 'Workshop 38', 'Europe/Minsk', '08:30', '17:30'),
(39, 'Workshop 39', 'Europe/Skopje', '09:00', '17:00'),
(40, 'Workshop 40', 'Europe/Jersey', '08:30', '16:30'),
(41, 'Workshop 41', 'Europe/San_Marino', '09:00', '17:30'),
(42, 'Workshop 42', 'Europe/Gibraltar', '08:30', '17:00'),
(43, 'Workshop 43', 'Europe/Belgrade', '09:00', '18:00'),
(44, 'Workshop 44', 'Europe/Guernsey', '08:30', '17:30'),
(45, 'Workshop 45', 'Europe/Ulyanovsk', '09:00', '17:00'),
(46, 'Workshop 46', 'Europe/Saratov', '08:30', '16:30'),
(47, 'Workshop 47', 'Europe/Vaduz', '09:00', '17:30'),
(48, 'Workshop 48', 'Europe/Uzhgorod', '08:30', '17:00'),
(49, 'Workshop 49', 'Europe/Kirov', '09:00', '18:00'),
(50, 'Workshop 50', 'Europe/Tirane', '08:30', '17:30'),
(51, 'Workshop 51', 'Europe/Tiraspol', '09:00', '17:00'),
(52, 'Workshop 52', 'Europe/Sarajevo', '08:30', '16:30'),
(53, 'Workshop 53', 'Europe/Podgorica', '09:00', '17:30'),
(54, 'Workshop 54', 'Europe/Busingen', '08:30', '17:00'),
(55, 'Workshop 55', 'Europe/Vatican', '09:00', '18:00'),
(56, 'Workshop 56', 'Europe/Belfast', '08:30', '17:30'),
(57, 'Workshop 57', 'Europe/Bratislava', '09:00', '17:00'),
(58, 'Workshop 58', 'Europe/Kiev', '08:30', '16:30'),
(59, 'Workshop 59', 'Europe/Kaliningrad', '09:00', '17:30'),
(60, 'Workshop 60', 'Europe/Zaporozhye', '08:30', '17:00'),
(61, 'Workshop 61', 'Europe/Budapest', '09:00', '18:00'),
(62, 'Workshop 62', 'Europe/Vilnius', '08:30', '17:30'),
(63, 'Workshop 63', 'Europe/Monaco', '09:00', '17:00'),
(64, 'Workshop 64', 'Europe/Astrakhan', '08:30', '16:30'),
(65, 'Workshop 65', 'Europe/Simferopol', '09:00', '17:30'),
(66, 'Workshop 66', 'Europe/Volgograd', '08:30', '17:00'),
(67, 'Workshop 67', 'Europe/Kyiv', '09:00', '18:00'),
(68, 'Workshop 68', 'Europe/Isle_of_Man', '08:30', '17:30'),
(69, 'Workshop 69', 'Europe/Riga', '09:00', '17:00'),
(70, 'Workshop 70', 'Europe/Andorra', '08:30', '16:30'),
(71, 'Workshop 71', 'Europe/Tallinn', '09:00', '17:30'),
(72, 'Workshop 72', 'Europe/Malta', '08:30', '17:00'),
(73, 'Workshop 73', 'Europe/Zagreb', '09:00', '18:00'),
(74, 'Workshop 74', 'Europe/Nicosia', '08:30', '17:30'),
(75, 'Workshop 75', 'Europe/Bucharest', '09:00', '17:00'),
(76, 'Workshop 76', 'Europe/Copenhagen', '08:30', '16:30'),
(77, 'Workshop 77', 'Europe/Chisinau', '09:00', '17:30'),
(78, 'Workshop 78', 'Europe/Mariehamn', '08:30', '17:00'),
(79, 'Workshop 79', 'Europe/Sofia', '09:00', '18:00'),
(80, 'Workshop 80', 'Europe/Athens', '08:30', '17:30'),
(81, 'Workshop 81', 'Europe/Samara', '09:00', '17:00');

-- Logic:
-- Take the raw data, convert all times to UTC
-- Generate a table with a row for every 30 minutes
-- join to the table and only return the times with distinct workshop count
-- order by slot and take earliest.
WITH time_spine AS (
  SELECT
  	dt::timestamp
  FROM generate_series('1999-01-01 00:00:00'::timestamp,
                       '1999-01-01 23:30:00'::timestamp,
  						'30 minute'::interval) dt
),
parsed_timestamps AS (
  SELECT
  	workshop_id,
  	workshop_name,
  	('1999-01-01'::date + business_start_time::time)AT TIME ZONE timezone AT TIME ZONE 'UTC' AS utc_start_time,
  	('1999-01-01'::date + business_end_time::time)AT TIME ZONE timezone AT TIME ZONE 'UTC' AS utc_end_time
  FROM workshops
)
--SELECT * FROM parsed_timestamps

SELECT 
	dt,
    COUNT(DISTINCT workshop_id) AS unique_count
FROM parsed_timestamps
  INNER JOIN time_spine ON dt BETWEEN utc_start_time AND utc_end_time
GROUP BY 1
HAVING COUNT(DISTINCT workshop_id) = (SELECT COUNT(DISTINCT workshop_id) FROM workshops)
ORDER BY 2 DESC
;

-- Returns no vaid meeting times.
-- If we take the max start time in UTC so the latest possible start date that the meeting can occur we get 14:30 (UTC of NY factory start)
-- The min end date so the earliest a meeting can end came before this start time. The expected answer on the site was 14:30 but logically it will NOT
-- work. 