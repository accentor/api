# == Schema Information
#
# Table name: tracks
#
#  id            :bigint(8)        not null, primary key
#  title         :string           not null
#  number        :integer          not null
#  audio_file_id :bigint(8)
#  album_id      :bigint(8)        not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Track < ApplicationRecord
  belongs_to :audio_file, optional: true, dependent: :destroy
  belongs_to :album
  has_and_belongs_to_many :genres
  has_many :track_artists, dependent: :destroy
  has_many :artists, through: :track_artists, source: :artist

  validates :title, presence: true
  validates :number, presence: true

  scope :by_album, ->(album) {where(album: album)}
  scope :by_genre, ->(genre) {joins(:genres).where(genres: {id: genre})}

  def merge(other)
    af = other.audio_file
    other.update(audio_file: nil)
    other.destroy
    audio_file.destroy if audio_file_id?
    update(audio_file: af)
  end
end
