# == Schema Information
#
# Table name: images
#
#  id            :bigint           not null, primary key
#  image_type_id :bigint           not null
#

FactoryBot.define do
  factory :image do
    image_type
    image { Rack::Test::UploadedFile.new(Rails.root.join('test/files/image.jpg'), 'image/jpeg') }
  end
end
