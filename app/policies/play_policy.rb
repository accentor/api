class PlayPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    user.present?
  end

  def permitted_attributes
    %i[user_id track_id played_at]
  end
end
