# == Schema Information
#
# Table name: album_labels
#
#  id               :bigint           not null, primary key
#  catalogue_number :string
#  album_id         :bigint           not null
#  label_id         :bigint           not null
#

FactoryBot.define do
  factory :album_label do
    album
    label
    catalogue_number {Faker::Lorem.word}
  end
end
