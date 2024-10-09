# frozen_string_literal: true

class QueueTranscodedItemsForCodecConversionJob < ApplicationJob
  queue_as :within_30_seconds

  def perform(codec_conversion)
    AudioFile.find_in_batches do |batch|
      jobs = batch.filter_map do |af|
        CreateTranscodedItemJob.new(af, codec_conversion) if Rails.configuration.queue_create_transcoded_item_if.call(af)
      end
      ActiveJob.perform_all_later(jobs)
    end
  end
end
