class CalculateContentLengthJob < ApplicationJob
  queue_as :within_5_minutes

  def perform(audio_file, codec_conversion)
    audio_file.calc_audio_length(codec_conversion)
  end
end
