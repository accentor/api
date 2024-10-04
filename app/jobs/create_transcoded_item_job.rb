class CreateTranscodedItemJob < ApplicationJob
  queue_as :within_30_seconds

  def perform(audio_file, codec_conversion)
    # Check that this transcoded_item was not created while this job was in the queue
    return if TranscodedItem.find_by(audio_file:, codec_conversion:).present?

    uuid = TranscodedItem.uuid_for(codec_conversion)
    path = TranscodedItem.path_for(codec_conversion, uuid)
    FileUtils.mkdir_p Pathname.new(path).parent
    audio_file.convert(codec_conversion, path)

    TranscodedItem.transaction do
      # Check that the transcoded item was not created while we were executing
      if TranscodedItem.find_by(audio_file:, codec_conversion:).present?
        FileUtils.rm_f path
      else
        TranscodedItem.create!(audio_file:, codec_conversion:, uuid:)
      end
    end
  end
end
