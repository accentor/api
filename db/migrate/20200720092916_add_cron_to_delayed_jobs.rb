class AddCronToDelayedJobs < ActiveRecord::Migration[6.0]
  def change
    add_column :delayed_jobs, :cron, :string

    Delayed::Job.enqueue(TranscodeCacheCleanJob.new, cron: '0 4 * * *')
  end
end
