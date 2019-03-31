json.extract! genre, :id, :name
json.tracks_url tracks_url(genre_id: genre.id, format: :json)
json.url genre_url(genre, format: :json)
