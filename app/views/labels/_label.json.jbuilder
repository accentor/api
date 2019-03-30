json.extract! label, :id, :name
json.albums_url albums_url(label: label.id, format: :json)
json.url label_url(label, format: :json)
