json.extract! track, :id, :title, :number, :album_id, :review_comment, :created_at, :updated_at
json.genre_ids track.genre_ids
json.track_artists do
  json.array! track.track_artists, partial: 'tracks/track_artist', as: :track_artist
end
json.codec track.audio_file&.codec
json.length track.audio_file&.length
json.bitrate track.audio_file&.bitrate
json.location_id track.audio_file&.location&.id
