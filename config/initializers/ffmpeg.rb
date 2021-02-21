require 'open3'

if Rails.env.test?
  # We don't require test setups to have FFMPEG installed, so can jsut manually set a version
  Rails.application.config.FFMPEG_VERSION = '0.0.1'
else
  stdin, stdout, = Open3.popen2('ffmpeg -version')
  stdin.close
  Rails.application.config.FFMPEG_VERSION = stdout.gets.match(/ffmpeg version (\d+\.\d+\.\d+)/)[1]
end
