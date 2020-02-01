json.extract! album, :id, :title, :normalized_title, :release, :review_comment, :edition, :edition_description, :created_at, :updated_at
json.album_labels do
  json.array! album.album_labels do |album_label|
    json.extract! album_label, :label_id, :catalogue_number
  end
end
json.album_artists do
  json.array! album.album_artists do |album_artist|
    json.extract! album_artist, :artist_id, :name, :normalized_name, :order, :separator
  end
end
json.image((album.image.present? && album.image.image.variable?) ? rails_blob_url(album.image.image) : nil)
json.image500((album.image.present? && album.image.image.variable?) ? rails_representation_url(album.image.image.variant(resize: "500x500>")) : nil)
json.image250((album.image.present? && album.image.image.variable?) ? rails_representation_url(album.image.image.variant(resize: "250x250>")) : nil)
json.image100((album.image.present? && album.image.image.variable?) ? rails_representation_url(album.image.image.variant(resize: "100x100>")) : nil)
json.image_type((album.image.present? && album.image.image.variable?) ? album.image.image_type.mimetype : nil)
