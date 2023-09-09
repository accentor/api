class CalculateContentLengthJob < ApplicationJob
  queue_as :content_lengths
  queue_with_priority 20

  def perform(audio_file, codec_conversion)
    audio_file.calc_audio_length(codec_conversion)
  end
end
