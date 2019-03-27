# == Schema Information
#
# Table name: cover_filenames
#
#  id       :bigint(8)        not null, primary key
#  filename :string           not null
#

FactoryBot.define do
  factory :cover_filename do
    filename { Faker::File.unique.file_name }
  end
end
