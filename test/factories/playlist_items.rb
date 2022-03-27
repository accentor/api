# == Schema Information
#
# Table name: playlist_items
#
#  id          :bigint           not null, primary key
#  item_type   :string           not null
#  order       :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  item_id     :integer          not null
#  playlist_id :bigint           not null
#
FactoryBot.define do
  factory :playlist_item do
    for_track
    order { 1 }

    trait :for_album do
      playlist { association :playlist, playlist_type: :album }
      association :item, factory: :album
    end

    trait :for_artist do
      playlist { association :playlist, playlist_type: :artist }
      association :item, factory: :artist
    end

    trait :for_track do
      playlist { association :playlist, playlist_type: :track }
      association :item, factory: :track
    end
  end
end
