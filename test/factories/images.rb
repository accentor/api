FactoryBot.define do
  factory :image do
    image_type
    image { fixture_file_upload(Rails.root.join('test', 'files', 'image.jpg'), 'image/jpg')}
  end
end
