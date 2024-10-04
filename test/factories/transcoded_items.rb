# == Schema Information
#
# Table name: transcoded_items
#
#  id                  :bigint           not null, primary key
#  uuid                :string           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  audio_file_id       :bigint           not null
#  codec_conversion_id :bigint           not null
#
FactoryBot.define do
  factory :transcoded_item do
    uuid { SecureRandom.uuid }
    audio_file
    codec_conversion
  end
end
