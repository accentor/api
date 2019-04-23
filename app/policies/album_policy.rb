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
    user
  end

  def destroy?
    create?
  end

  def destroy_empty?
    create?
  end

  def permitted_attributes
    if user.moderator?
      [
          :title,
          :albumartist,
          :release,
          :review_comment,
          image: [:data, :filename, :mimetype],
          album_labels: [:label_id, :catalogue_number]
      ]
    else
      [:review_comment]
    end
  end

end
