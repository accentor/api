# == Schema Information
#
# Table name: locations
#
#  id         :bigint           not null, primary key
#  path       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_locations_on_path  (path) UNIQUE
#

FactoryBot.define do
  factory :location do
    path { Faker::File.file_name }
  end
end
