FactoryBot.define do
  factory :cover_filename do
    filename { Faker::File.unique.file_name }
  end
end
