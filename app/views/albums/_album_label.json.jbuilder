json.extract! album_label, :label_id, :catalogue_number
json.label_url label_url(album_label.label, format: :json)
