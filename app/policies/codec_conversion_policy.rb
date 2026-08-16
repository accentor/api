class CodecConversionPolicy < ApplicationPolicy
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

  def permitted_attributes
    %i[name ffmpeg_params resulting_codec_id]
  end
end
