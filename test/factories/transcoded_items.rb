# == Schema Information
#
# Table name: transcoded_items
#
#  id                  :bigint           not null, primary key
#  last_used           :datetime         not null
#  path                :string           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  audio_file_id       :bigint           not null
#  codec_conversion_id :bigint           not null
#
FactoryBot.define do
  factory :transcoded_item do
    path { Rails.root.join('tmp/storage', SecureRandom.uuid) }
    last_used { '2020-07-20 09:33:51' }
    audio_file
    codec_conversion
  end
end
