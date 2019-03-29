# == Schema Information
#
# Table name: images
#
#  id            :bigint(8)        not null, primary key
#  image_type_id :bigint(8)        not null
#

FactoryBot.define do
  factory :image do
    image_type
    image {fixture_file_upload(Rails.root.join('test', 'files', 'image.jpg'), 'image/jpeg')}
  end
end
