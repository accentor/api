class RecalculateContentLengthsJob < ApplicationJob
  queue_as :within_5_minutes

  def perform
    AudioFile.find_each do |af|
      next unless Rails.application.config.recalculate_content_length_if.call af

      CodecConversion.find_each do |cc|
        CalculateContentLengthJob.set(queue: :whenever).perform_later(af, cc)
      end
    end
  end
end
