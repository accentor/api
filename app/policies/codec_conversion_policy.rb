class CodecConversionPolicy < ApplicationPolicy
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
    create?
  end

  def destroy?
    create?
  end

  def permitted_attributes
    [:name, :ffmpeg_params, :resulting_codec_id]
  end
end
