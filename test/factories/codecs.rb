FactoryBot.define do
  factory :codec do
    mimetype {Faker::File.mime_type}
    extension {Faker::File.unique.extension}
  end
end
