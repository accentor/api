class PlayPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(user_id: user.id)
    end
  end

  def create?
    user.present?
  end

  def permitted_attributes
    %i[track_id played_at]
  end
end
