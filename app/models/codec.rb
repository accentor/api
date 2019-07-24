# == Schema Information
#
# Table name: codecs
#
#  id        :bigint           not null, primary key
#  mimetype  :string           not null
#  extension :string           not null
#

class Codec < ApplicationRecord
  has_many :audio_files, dependent: :restrict_with_error
  has_many :codec_conversions, foreign_key: :resulting_codec_id, inverse_of: :resulting_codec, dependent: :destroy

  validates :mimetype, presence: true
  validates :extension, presence: true, uniqueness: true
end
