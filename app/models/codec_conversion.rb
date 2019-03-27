class CodecConversion < ApplicationRecord
  belongs_to :resulting_codec, class_name: 'Codec'

  validates :name, presence: true, uniqueness: true
  validates :ffmpeg_params, presence: true
  validates :resulting_codec, presence: true

  scope :by_codec, ->(codec) {where(resulting_codec: codec)}
end
