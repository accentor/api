# frozen_string_literal: true

namespace :ffmpeg do
  task queue_version_checks: :environment do
    ContentLength.find_each do |cl|
      cl.delay(queue: :content_lengths).check_ffmpeg_version
    end
  end
end
