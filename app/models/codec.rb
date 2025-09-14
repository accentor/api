# == Schema Information
#
# Table name: codecs
#
#  id         :bigint           not null, primary key
#  extension  :string           not null
#  mimetype   :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_codecs_on_extension  (extension) UNIQUE
#

class Codec < ApplicationRecord
  has_many :audio_files, dependent: :restrict_with_error
  has_many :codec_conversions, foreign_key: :resulting_codec_id, inverse_of: :resulting_codec, dependent: :destroy

  validates :mimetype, presence: true
  validates :extension, presence: true, uniqueness: true
end
