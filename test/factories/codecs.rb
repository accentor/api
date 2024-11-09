# == Schema Information
#
# Table name: codecs
#
#  id        :bigint           not null, primary key
#  extension :string           not null
#  mimetype  :string           not null
#
# Indexes
#
#  index_codecs_on_extension  (extension) UNIQUE
#

FactoryBot.define do
  factory :codec do
    mimetype { Faker::File.mime_type }
    extension { Faker::Lorem.unique.word }
  end
end
