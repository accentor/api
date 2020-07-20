class TranscodeCacheCleanJob < ApplicationJob
  queue_as :transcode_cache_cleaner

  def perform
    TranscodedItem.where.not(last_used: (3.days.ago..)).destroy_all
  end
end
