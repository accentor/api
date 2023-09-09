class RunRescanJob < ApplicationJob
  queue_as :within_5_minutes

  def perform(rescan_runner)
    rescan_runner.run
  end
end
