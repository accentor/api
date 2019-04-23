json.extract! album, :id, :title, :release, :review_comment, :created_at, :updated_at
json.album_labels do
  json.array! album.album_labels, partial: 'albums/album_label', as: :album_label
end
json.album_artists do
  json.array! album.album_artists, partial: 'albums/album_artist', as: :album_artist
end
json.image album.image.present? ? rails_blob_url(album.image.image) : nil
json.image_type album.image.present? ? album.image.image_type.mimetype : nil
