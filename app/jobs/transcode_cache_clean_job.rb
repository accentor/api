class TranscodeCacheCleanJob < ApplicationJob
  queue_as :transcode_cache_cleaner

  def perform
    TranscodedItem.where.not(last_used: (Rails.configuration.transcode_cache_expiry.call..)).destroy_all
  end
end
