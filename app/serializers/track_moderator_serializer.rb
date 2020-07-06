class TrackModeratorSerializer < TrackSerializer
  attributes :filename, :sample_rate, :bit_depth

  def filename
    object.audio_file&.filename
  end

  def sample_rate
    object.audio_file&.sample_rate
  end

  def bit_depth
    object.audio_file&.bit_depth
  end
end
