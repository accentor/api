# == Schema Information
#
# Table name: albums
#
#  id                  :bigint           not null, primary key
#  edition             :date
#  edition_description :string
#  normalized_title    :string           not null
#  release             :date
#  review_comment      :string
#  title               :string           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  image_id            :bigint
#
class AlbumSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :title, :normalized_title, :release, :review_comment, :edition, :edition_description, :created_at, :updated_at, :image, :image100, :image250, :image500, :image_type

  has_many :album_artists
  has_many :album_labels

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
