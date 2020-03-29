class CodecConversionSerializer < ActiveModel::Serializer
  attributes :id, :name, :ffmpeg_params, :resulting_codec_id
end
