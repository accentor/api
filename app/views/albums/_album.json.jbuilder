json.extract! album, :id, :title, :albumartist, :release, :created_at, :updated_at
json.image album.image.present? ? rails_blob_url(album.image.image) : nil
json.image_type album.image.present? ? album.image.image_type.mimetype : nil
json.url album_url(album, format: :json)
