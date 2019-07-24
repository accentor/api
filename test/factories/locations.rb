# == Schema Information
#
# Table name: locations
#
#  id   :bigint           not null, primary key
#  path :string           not null
#

FactoryBot.define do
  factory :location do
    path { Faker::File.file_name }
  end
end
