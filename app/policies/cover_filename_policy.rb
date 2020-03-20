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

class CoverFilenamePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    user&.moderator?
  end

  def show?
    user&.moderator?
  end

  def create?
    user&.moderator?
  end

  def destroy?
    user&.moderator?
  end

  def permitted_attributes
    [:filename]
  end
end
