class TrackWithFilenameSerializer < TrackSerializer
  attribute :filename

  def filename
    object.audio_file&.filename
  end
end
