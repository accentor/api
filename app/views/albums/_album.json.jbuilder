json.extract! album, :id, :title, :albumartist, :release, :created_at, :updated_at
json.album_labels do
  json.array! album.album_labels, partial: 'albums/album_label', as: :album_label
end
json.image album.image.present? ? rails_blob_url(album.image.image) : nil
json.image_type album.image.present? ? album.image.image_type.mimetype : nil
json.url album_url(album, format: :json)
json.tracks_url tracks_url(album_id: album.id, format: :json)
