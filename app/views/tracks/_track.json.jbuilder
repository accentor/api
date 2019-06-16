json.extract! track, :id, :title, :number, :album_id, :review_comment, :created_at, :updated_at
json.genre_ids track.genre_ids
json.track_artists do
  json.array! track.track_artists do  |track_artist|
    json.extract! track_artist, :artist_id, :name, :role, :order
  end
end
json.codec_id track.audio_file&.codec&.id
json.length track.audio_file&.length
json.bitrate track.audio_file&.bitrate
json.location_id track.audio_file&.location&.id
