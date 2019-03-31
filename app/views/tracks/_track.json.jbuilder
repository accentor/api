json.extract! track, :id, :title, :number, :album_id, :created_at, :updated_at
json.genre_ids track.genre_ids
json.track_artists do
  json.array! track.track_artists, partial: 'tracks/track_artist', as: :track_artist
end
json.codec track.audio_file&.codec
json.length track.audio_file&.length
json.bitrate track.audio_file&.bitrate
json.location_id track.audio_file&.location&.id
json.location_url(if track.audio_file&.location.present?
                    location_url(track.audio_file&.location, format: :json)
                  end)
json.album_url album_url(track.album, format: :json)
json.url track_url(track, format: :json)
