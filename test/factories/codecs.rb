# == Schema Information
#
# Table name: codecs
#
#  id        :bigint(8)        not null, primary key
#  mimetype  :string           not null
#  extension :string           not null
#

FactoryBot.define do
  factory :codec do
    mimetype {Faker::File.mime_type}
    extension {Faker::File.unique.extension}
  end
end
