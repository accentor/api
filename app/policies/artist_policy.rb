# == Schema Information
#
# Table name: tracks
#
#  id               :bigint           not null, primary key
#  normalized_title :string           not null
#  number           :integer          not null
#  review_comment   :string
#  title            :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  album_id         :bigint           not null
#  audio_file_id    :bigint
#

class ArtistPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    user.present?
  end

  def show?
    index?
  end

  def create?
    user&.moderator?
  end

  def update?
    user
  end

  def destroy?
    create?
  end

  def destroy_empty?
    create?
  end

  def permitted_attributes
    if user.moderator?
      [:name, :review_comment, image: [:data, :filename, :mimetype]]
    else
      [:review_comment]
    end
  end
end
