# == Schema Information
#
# Table name: codecs
#
#  id        :bigint           not null, primary key
#  extension :string           not null
#  mimetype  :string           not null
#

FactoryBot.define do
  factory :codec do
    mimetype {Faker::File.mime_type}
    extension {Faker::File.unique.extension}
  end
end
