# == Schema Information
#
# Table name: artists
#
#  id              :bigint           not null, primary key
#  name            :string           not null
#  normalized_name :string           not null
#  review_comment  :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  image_id        :bigint
#
class ArtistSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :name, :normalized_name, :review_comment, :created_at, :updated_at, :image, :image100, :image250, :image500, :image_type

  def image
    return nil if object.image.blank?
    return nil unless object.image.image.variable?

    rails_blob_url(object.image.image, **scope)
  end

  def image100
    return nil if object.image.blank?
    return nil unless object.image.image.variable?

    rails_representation_url(object.image.image.variant(resize_to_limit: [100, 100]), **scope)
  end

  def image250
    return nil if object.image.blank?
    return nil unless object.image.image.variable?

    rails_representation_url(object.image.image.variant(resize_to_limit: [250, 250]), **scope)
  end

  def image500
    return nil if object.image.blank?
    return nil unless object.image.image.variable?

    rails_representation_url(object.image.image.variant(resize_to_limit: [500, 500]), **scope)
  end

  def image_type
    return nil if object.image.blank?
    return nil unless object.image.image.variable?

    object.image.image_type.mimetype
  end
end
