require 'open3'

# ffmpeg versions can be either x.x.x or x.x
FFMPEG_REGEX = /ffmpeg version (\d+\.\d+\.?\d*)/

namespace :ffmpeg do
  task check_version: :environment do
    path = ENV.fetch('FFMPEG_VERSION_LOCATION') { Rails.root.join('log/ffmpeg_version.txt').to_s }
    prev_version = begin
      File.read(path)
    rescue StandardError
      '0.0.0'
    end

    stdin, stdout, = Open3.popen2('ffmpeg -version')
    stdin.close
    new_version = stdout.gets.match(FFMPEG_REGEX)[1]

    exit if prev_version == new_version

    ContentLength.destroy_all
    RecalculateContentLengthsJob.perform_later

    File.write(path, new_version)
  end

  task init: :environment do
    path = ENV.fetch('FFMPEG_VERSION_LOCATION') { Rails.root.join('log/ffmpeg_version.txt') }
    abort("The ffmpeg version file already exists: #{path}") if File.exist?(path)

    stdin, stdout, = Open3.popen2('ffmpeg -version')
    stdin.close
    version = stdout.gets.match(FFMPEG_REGEX)[1]
    File.write(path, version)
  end
end
