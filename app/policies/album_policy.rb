class AlbumPolicy < ApplicationPolicy
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

  def destroy_empty?
    create?
  end

  def permitted_attributes
    [
        :title,
        :albumartist,
        :release,
        image: [:data, :filename, :mimetype],
        album_labels: [:label_id, :catalogue_number]
    ]
  end

end
