json.extract! album, :id, :title, :albumartist, :release, :review_comment, :created_at, :updated_at
json.album_labels do
  json.array! album.album_labels, partial: 'albums/album_label', as: :album_label
end
json.image album.image.present? ? rails_blob_url(album.image.image) : nil
json.image_type album.image.present? ? album.image.image_type.mimetype : nil
