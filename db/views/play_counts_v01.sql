-- This view generates a count per user/track
SELECT
  users.id as user_id,
  tracks.id as track_id,
  COUNT(plays.id) as play_count
FROM
  tracks
  LEFT OUTER JOIN users ON true = true
  LEFT OUTER JOIN plays ON tracks.id = plays.track_id
  AND users.id = plays.user_id
GROUP BY
  users.id,
  tracks.id