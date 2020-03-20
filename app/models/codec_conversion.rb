# == Schema Information
#
# Table name: codec_conversions
#
#  id                 :bigint           not null, primary key
#  ffmpeg_params      :string           not null
#  name               :string           not null
#  resulting_codec_id :bigint           not null
#

class CodecConversion < ApplicationRecord
  belongs_to :resulting_codec, class_name: 'Codec'
  has_many :content_lengths, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :ffmpeg_params, presence: true
  validates :resulting_codec, presence: true

  scope :by_codec, ->(codec) {where(resulting_codec: codec)}

  after_save :queue_content_length_calculations

  def queue_content_length_calculations
    ContentLength.where(codec_conversion: self).destroy_all
    AudioFile.find_each do |af|
      af.delay(priority: 10).calc_audio_length(self)
    end
  end
end
