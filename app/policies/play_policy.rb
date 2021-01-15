class PlayPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if Rails.configuration.plays_are_public
        scope.all
      else
        scope.where(user: user)
      end
    end
  end

  def index?
    user.present?
  end

  def create?
    user.present?
  end

  def permitted_attributes
    %i[track_id played_at]
  end
end
