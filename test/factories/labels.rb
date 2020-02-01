# == Schema Information
#
# Table name: labels
#
#  id              :bigint           not null, primary key
#  name            :string           not null
#  normalized_name :string           not null
#
# Indexes
#
#  index_labels_on_normalized_name  (normalized_name)
#

FactoryBot.define do
  factory :label do
    name {Faker::Lorem.word}
  end
end
