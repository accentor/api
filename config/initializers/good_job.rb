# frozen_string_literal: true

Rails.application.configure do
  # Opt-in to default behaviour for priority in Active Job
  # See: https://github.com/bensheldon/good_job/pull/883
  config.good_job.smaller_number_is_higher_priority = true
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
