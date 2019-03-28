# == Schema Information
#
# Table name: codec_conversions
#
#  id                 :bigint(8)        not null, primary key
#  name               :string           not null
#  ffmpeg_params      :string           not null
#  resulting_codec_id :bigint(8)        not null
#

class CodecConversion < ApplicationRecord
  belongs_to :resulting_codec, class_name: 'Codec'

  validates :name, presence: true, uniqueness: true
  validates :ffmpeg_params, presence: true
  validates :resulting_codec, presence: true

  scope :by_codec, ->(codec) {where(resulting_codec: codec)}
end
