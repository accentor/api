json.extract! codec, :id, :mimetype, :extension
json.url codec_url(codec, format: :json)
json.codec_conversions_url codec_conversions_url(codec: codec, format: :json)
