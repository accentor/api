# == Schema Information
#
# Table name: images
#
#  id            :bigint           not null, primary key
#  image_type_id :bigint           not null
#
# Indexes
#
#  index_images_on_image_type_id  (image_type_id)
#
# Foreign Keys
#
#  fk_rails_...  (image_type_id => image_types.id)
#

FactoryBot.define do
  factory :image do
    image_type
    image {fixture_file_upload(Rails.root.join('test', 'files', 'image.jpg'), 'image/jpeg')}
  end
end
