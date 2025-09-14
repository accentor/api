# == Schema Information
#
# Table name: audio_files
#
#  id          :bigint           not null, primary key
#  bit_depth   :integer          not null
#  bitrate     :integer          not null
#  filename    :string           not null
#  length      :integer          not null
#  sample_rate :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  codec_id    :bigint           not null
#  location_id :bigint           not null
#
# Indexes
#
#  index_audio_files_on_codec_id                  (codec_id)
#  index_audio_files_on_location_id               (location_id)
#  index_audio_files_on_location_id_and_filename  (location_id,filename) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (codec_id => codecs.id)
#  fk_rails_...  (location_id => locations.id)
#

FactoryBot.define do
  factory :audio_file do
    location
    codec
    filename { Faker::File.unique.file_name }
    length { Random.rand(1_000_000) }
    bitrate { Random.rand(1000) }
    sample_rate { Random.rand(10_000) }
    bit_depth { Random.rand(10) }
  end
end
