# == Schema Information
#
# Table name: codec_conversions
#
#  id                 :bigint           not null, primary key
#  ffmpeg_params      :string           not null
#  name               :string           not null
#  resulting_codec_id :bigint           not null
#
# Indexes
#
#  index_codec_conversions_on_name                (name) UNIQUE
#  index_codec_conversions_on_resulting_codec_id  (resulting_codec_id)
#
# Foreign Keys
#
#  fk_rails_...  (resulting_codec_id => codecs.id)
#
class CodecConversionSerializer < ActiveModel::Serializer
  attributes :id, :name, :ffmpeg_params, :resulting_codec_id
end
