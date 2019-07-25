json.extract! artist, :id, :name, :review_comment, :created_at, :updated_at
json.image((artist.image.present? && artist.image.image.variable?) ? rails_blob_url(artist.image.image) : nil)
json.image500((artist.image.present? && artist.image.image.variable?) ? rails_representation_url(artist.image.image.variant(resize: "500x500>")) : nil)
json.image250((artist.image.present? && artist.image.image.variable?) ? rails_representation_url(artist.image.image.variant(resize: "250x250>")) : nil)
json.image100((artist.image.present? && artist.image.image.variable?) ? rails_representation_url(artist.image.image.variant(resize: "100x100>")) : nil)
json.image_type((artist.image.present? && artist.image.image.variable?) ? artist.image.image_type.mimetype : nil)
