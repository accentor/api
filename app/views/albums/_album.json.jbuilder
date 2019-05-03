json.extract! album, :id, :title, :release, :review_comment, :edition, :edition_description, :created_at, :updated_at
json.album_labels do
  json.array! album.album_labels do |album_label|
    json.extract! album_label, :label_id, :catalogue_number
  end
end
json.album_artists do
  json.array! album.album_artists do |album_artist|
    json.extract! album_artist, :artist_id, :name, :order, :separator
  end
end
json.image album.image.present? ? rails_blob_url(album.image.image) : nil
json.image_type album.image.present? ? album.image.image_type.mimetype : nil
