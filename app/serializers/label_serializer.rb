# == Schema Information
#
# Table name: labels
#
#  id              :bigint           not null, primary key
#  name            :string           not null
#  normalized_name :string           not null
#
class LabelSerializer < ActiveModel::Serializer
  attributes :id, :name, :normalized_name
end
