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
