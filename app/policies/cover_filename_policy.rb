# == Schema Information
#
# Table name: tracks
#
#  id               :bigint           not null, primary key
#  normalized_title :string           not null
#  number           :integer          not null
#  review_comment   :string
#  title            :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  album_id         :bigint           not null
#  audio_file_id    :bigint
#
# Indexes
#
#  index_tracks_on_album_id          (album_id)
#  index_tracks_on_audio_file_id     (audio_file_id) UNIQUE
#  index_tracks_on_normalized_title  (normalized_title)
#
# Foreign Keys
#
#  fk_rails_...  (album_id => albums.id)
#  fk_rails_...  (audio_file_id => audio_files.id)
#

class CoverFilenamePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    user&.moderator?
  end

  def show?
    user&.moderator?
  end

  def create?
    user&.moderator?
  end

  def destroy?
    user&.moderator?
  end

  def permitted_attributes
    [:filename]
  end
end
