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
class LabelSerializer < ActiveModel::Serializer
  attributes :id, :name, :normalized_name
end
