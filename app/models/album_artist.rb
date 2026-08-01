# == Schema Information
#
# Table name: album_artists
#
#  id              :bigint           not null, primary key
#  name            :string           not null
#  normalized_name :string           not null
#  order           :integer          not null
#  separator       :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  album_id        :bigint           not null
#  artist_id       :bigint           not null
#
# Indexes
#
#  index_album_artists_on_album_id                         (album_id)
#  index_album_artists_on_album_id_and_artist_id_and_name  (album_id,artist_id,name) UNIQUE
#  index_album_artists_on_artist_id                        (artist_id)
#  index_album_artists_on_normalized_name                  (normalized_name)
#
# Foreign Keys
#
#  fk_rails_...  (album_id => albums.id)
#  fk_rails_...  (artist_id => artists.id)
#

class AlbumArtist < ApplicationRecord
  include HasNormalized

  belongs_to :album, touch: true
  belongs_to :artist

  validates :name, presence: true
  validates :order, presence: true
  validate :separator_not_nil, unless: :last_item?
  validates :separator, absence: { allow_blank: false }, if: :last_item?

  normalized_col_generator :name

  private

  def last_item?
    order == album.album_artists.size
  end

  def separator_not_nil
    errors.add(:separator, :blank) if separator.nil?
  end
end
