# == Schema Information
#
# Table name: tracks
#
#  id               :bigint           not null, primary key
#  normalized_title :string           not null
#  number           :integer          not null
#  review_comment   :string
#  title            :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  album_id         :bigint           not null
#  audio_file_id    :bigint
#
# Indexes
#
#  index_tracks_on_album_id          (album_id)
#  index_tracks_on_audio_file_id     (audio_file_id) UNIQUE
#  index_tracks_on_normalized_title  (normalized_title)
#
# Foreign Keys
#
#  fk_rails_...  (album_id => albums.id)
#  fk_rails_...  (audio_file_id => audio_files.id)
#

FactoryBot.define do
  factory :track do
    album
    title {Faker::Lorem.word}
    number {Random.rand(20)}
    review_comment {Faker::Lorem.word}
    trait :with_audio_file do
      association :audio_file, factory: :audio_file
    end
  end
end
