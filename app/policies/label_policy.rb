class LabelPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index? = true
  def show? = true
  def create? = user.moderator?
  def update? = create?
  def destroy? = create?
  def destroy_empty? = create?
  def merge? = create?

  def permitted_attributes
    [:name]
  end
end
