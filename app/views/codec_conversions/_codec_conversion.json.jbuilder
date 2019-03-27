json.extract! codec_conversion, :id, :name, :ffmpeg_params, :resulting_codec_id
json.url codec_conversion_url(codec_conversion, format: :json)
json.resulting_codec_url codec_url(codec_conversion.resulting_codec, format: :json)
