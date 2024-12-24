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