# == Schema Information
#
# Table name: codec_conversions
#
#  id                 :bigint           not null, primary key
#  ffmpeg_params      :string           not null
#  name               :string           not null
#  resulting_codec_id :bigint           not null
#
class CodecConversionSerializer < ActiveModel::Serializer
  attributes :id, :name, :ffmpeg_params, :resulting_codec_id
end
