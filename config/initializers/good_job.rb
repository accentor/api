# frozen_string_literal: true

Rails.application.configure do
  # GoodJob recurring jobs
  # See https://github.com/bensheldon/good_job#cron-style-repeatingrecurring-jobs
  config.good_job.enable_cron = true
  config.good_job.cron = {
    clean_transcode_cache: {
      cron: 'every 4 hours',
      class: 'TranscodeCacheCleanJob'
    }
  }
end
