require 'open3'

namespace :ffmpeg do
  task check_version: :environment do
    path = ENV['FFMPEG_VERSION_LOCATION'] || Rails.root.join('log/ffmpeg_version.txt').to_s
    prev_version = File.read(path)

    stdin, stdout, = Open3.popen2('ffmpeg -version')
    stdin.close
    # ffmpeg versions can be either x.x.x or x.x
    new_version = stdout.gets.match(/ffmpeg version (\d+\.\d+\.?\d*)/)[1]

    exit if prev_version == new_version

    ContentLength.delay(queue: :content_lengths).destroy_all_and_recalculate

    File.write(path, new_version)
  end

  task init: :environment do
    path = ENV['FFMPEG_VERSION_LOCATION'] || Rails.root.join('log/ffmpeg_version.txt')
    exit if File.exist?(path)

    stdin, stdout, = Open3.popen2('ffmpeg -version')
    stdin.close
    # ffmpeg versions can be either x.x.x or x.x
    version = stdout.gets.match(/ffmpeg version (\d+\.\d+\.?\d*)/)[1]
    File.write(path, version)
  end
end
