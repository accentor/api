# frozen_string_literal: true

# use eslint for JS code styling
namespace :ffmpeg do
  task queue_check: :environment do
    ContentLength.find_each do |cl|
      cl.delay(queue: :content_lengths).check_ffmpeg_version
    end
  end
end
