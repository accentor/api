class PlayPolicy < ApplicationPolicy
  def create?
    user.present?
  end

  def permitted_attributes
    %i[track_id played_at]
  end
end
