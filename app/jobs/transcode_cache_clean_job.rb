class TranscodeCacheCleanJob < ApplicationJob
  queue_as :within_30_minutes

  def perform
    TranscodedItem.where.not(last_used: (Rails.configuration.transcode_cache_expiry.call..)).destroy_all
  end
end
