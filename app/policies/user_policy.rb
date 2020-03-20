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

class UserPolicy < ApplicationPolicy
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
    user&.admin?
  end

  def update?
    user == record || user&.admin?
  end

  def destroy?
    update?
  end

  def permitted_attributes
    if user.admin?
      %i[name password password_confirmation permission]
    else
      %i[name password password_confirmation]
    end
  end
end
