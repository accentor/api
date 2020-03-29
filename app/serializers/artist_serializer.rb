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

    rails_representation_url(object.image.image.variant(resize: '100x100>'), **scope)
  end

  def image250
    return nil if object.image.blank?
    return nil unless object.image.image.variable?

    rails_representation_url(object.image.image.variant(resize: '250x250>'), **scope)
  end

  def image500
    return nil if object.image.blank?
    return nil unless object.image.image.variable?

    rails_representation_url(object.image.image.variant(resize: '500x500>'), **scope)
  end

  def image_type
    return nil if object.image.blank?
    return nil unless object.image.image.variable?

    object.image.image_type.mimetype
  end
end
