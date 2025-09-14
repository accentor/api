user = User.create(name: 'admin', password: 'admin', permission: :admin)

if Rails.env.development?
  AuthToken.create(user:, user_agent: 'Rails', device_id: 'device-id')
end

Codec.create(mimetype: 'audio/flac', extension: 'flac')
mp3 = Codec.create(mimetype: 'audio/mpeg', extension: 'mp3')

CoverFilename.create(filename: 'folder')
CoverFilename.create(filename: 'cover')
CoverFilename.create(filename: 'front')

ImageType.create(mimetype: 'image/jpeg', extension: 'jpg')
ImageType.create(mimetype: 'image/jpeg', extension: 'jpeg')
ImageType.create(mimetype: 'image/png', extension: 'png')

CodecConversion.create(name: 'MP3 (V0)', ffmpeg_params: '-acodec mp3 -q:a 0', resulting_codec: mp3)
CodecConversion.create(name: 'MP3 (V2)', ffmpeg_params: '-acodec mp3 -q:a 2', resulting_codec: mp3)

if File.directory? File.expand_path('~/music')
  Location.create(path: File.expand_path('~/music'))
elsif File.directory? File.expand_path('~/Music')
  Location.create(path: File.expand_path('~/Music'))
end

RescanRunner.schedule_all
