# == Schema Information
#
# Table name: audio_files
#
#  id          :bigint(8)        not null, primary key
#  location_id :bigint(8)        not null
#  codec_id    :bigint(8)        not null
#  filename    :string           not null
#  length      :integer          not null
#  bitrate     :integer          not null
#

class AudioFile < ApplicationRecord
  belongs_to :location
  belongs_to :codec

  validates :location, presence: true
  validates :codec, presence: true
  validates :filename, presence: true, uniqueness: {scope: :location}
  validates :length, presence: true
  validates :bitrate, presence: true
end
