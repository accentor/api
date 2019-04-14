# == Schema Information
#
# Table name: image_types
#
#  id        :bigint(8)        not null, primary key
#  extension :string           not null
#  mimetype  :string           not null
#

FactoryBot.define do
  factory :image_type do
    mimetype {Faker::File.mime_type}
    extension {Faker::File.unique.extension}
  end
end
