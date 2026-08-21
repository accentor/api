class CodecPolicy < ApplicationPolicy
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

  def permitted_attributes_for_create
    return unless user.moderator?

    %i[mimetype extension]
  end

  def permitted_attributes_for_update
    return unless user.moderator?

    [:mimetype]
  end
end
