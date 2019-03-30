# == Schema Information
#
# Table name: album_labels
#
#  id               :bigint(8)        not null, primary key
#  album_id         :bigint(8)        not null
#  label_id         :bigint(8)        not null
#  catalogue_number :string           not null
#

FactoryBot.define do
  factory :album_label do
    album
    label
    catalogue_number {Faker::Lorem.word}
  end
end
