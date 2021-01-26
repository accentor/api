Delayed::Worker.destroy_failed_jobs = true
Delayed::Worker.max_attempts = 1
Delayed::Worker.max_run_time = 1.day
Delayed::Worker.raise_signal_exceptions = :term
Delayed::Worker.logger = if ENV['RAILS_LOG_TO_STDOUT'].present?
                           Logger.new($stdout)
                         else
                           Logger.new(Rails.root.join("log/delayed_job_#{Rails.env}.log"))
                         end
Delayed::Worker.queue_attributes = {
  transcodes: { priority: 5 },
  rescans: { priority: 10 },
  content_lengths: { priority: 20 },
  transcode_cache_cleaner: { priority: 100 }
}
