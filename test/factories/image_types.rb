# == Schema Information
#
# Table name: image_types
#
#  id         :bigint           not null, primary key
#  extension  :string           not null
#  mimetype   :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_image_types_on_extension  (extension) UNIQUE
#

FactoryBot.define do
  factory :image_type do
    mimetype { Faker::File.mime_type }
    extension { Faker::File.unique.extension }
  end
end
