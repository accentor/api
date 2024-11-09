# == Schema Information
#
# Table name: cover_filenames
#
#  id       :bigint           not null, primary key
#  filename :string           not null
#
# Indexes
#
#  index_cover_filenames_on_filename  (filename) UNIQUE
#

FactoryBot.define do
  factory :cover_filename do
    filename { Faker::File.unique.file_name }
  end
end
