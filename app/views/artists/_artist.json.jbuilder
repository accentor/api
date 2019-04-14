json.extract! artist, :id, :name, :created_at, :updated_at
json.image artist.image.present? ? rails_blob_url(artist.image.image) : nil
json.image_type artist.image.present? ? artist.image.image_type.mimetype : nil
