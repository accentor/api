# == Schema Information
#
# Table name: content_lengths
#
#  id                  :bigint           not null, primary key
#  length              :integer          not null
#  audio_file_id       :bigint           not null
#  codec_conversion_id :bigint           not null
#
# Indexes
#
#  index_content_lengths_on_audio_file_id                          (audio_file_id)
#  index_content_lengths_on_audio_file_id_and_codec_conversion_id  (audio_file_id,codec_conversion_id) UNIQUE
#  index_content_lengths_on_codec_conversion_id                    (codec_conversion_id)
#
# Foreign Keys
#
#  fk_rails_...  (audio_file_id => audio_files.id)
#  fk_rails_...  (codec_conversion_id => codec_conversions.id)
#

class ContentLength < ApplicationRecord
  belongs_to :audio_file
  belongs_to :codec_conversion

  validates :audio_file, presence: true, uniqueness: {scope: :codec_conversion}
  validates :codec_conversion, presence: true
  validates :length, presence: true
end
