class TranscodeCacheCleanJob < ApplicationJob
  queue_as :within_30_minuts

  def perform
    TranscodedItem.where.not(last_used: (Rails.configuration.transcode_cache_expiry.call..)).destroy_all
  end
end
