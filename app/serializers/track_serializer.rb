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
class TrackSerializer < ActiveModel::Serializer
  attributes :id, :title, :normalized_title, :number, :album_id, :review_comment, :created_at, :updated_at, :genre_ids, :codec_id, :length, :bitrate, :location_id

  has_many :track_artists

  def codec_id
    object.audio_file&.codec_id
  end

  def length
    object.audio_file&.length
  end

  def bitrate
    object.audio_file&.bitrate
  end

  def location_id
    object.audio_file&.location_id
  end
end
