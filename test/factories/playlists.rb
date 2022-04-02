# == Schema Information
#
# Table name: playlists
#
#  id            :bigint           not null, primary key
#  description   :string
#  name          :string           not null
#  playlist_type :integer          not null
#  private       :boolean          default(FALSE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :bigint
#
FactoryBot.define do
  factory :playlist do
    name { Faker::Lorem.word }
    playlist_type { %i[album artist track].sample }

    trait :personal do
      user
    end

    trait :private do
      user
      private { true }
    end
  end
end
