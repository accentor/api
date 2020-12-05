require 'test_helper'

class TracksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @track = create(:track, :with_audio_file)
    sign_in_as(create(:user))
  end

  test 'should get index with filenames for moderator' do
    sign_in_as(create(:moderator))
    get tracks_url
    assert_response :success
    body = ActiveSupport::JSON.decode response.body
    assert_equal @track.audio_file&.filename, body.first['filename']
  end

  test 'should get index without filenames for user' do
    get tracks_url
    assert_response :success
    body = ActiveSupport::JSON.decode response.body
    assert_nil body.first['filename']
  end

  test 'should not create track for user' do
    assert_difference('Track.count', 0) do
      post tracks_url, params: { track: { album_id: @track.album_id, number: @track.number, title: @track.title } }
    end

    assert_response :forbidden
  end

  test 'should create track for moderator' do
    sign_in_as(create(:moderator))
    track = build(:track, album: @track.album)
    genres = create_list(:genre, 5)
    track_artists = (1..5).map do |_|
      {
        artist_id: create(:artist).id,
        name: Faker::Artist.name,
        role: TrackArtist.roles.to_a.sample[0]
      }
    end

    assert_difference('Track.count', 1) do
      post tracks_url, params: { track: {
        album_id: track.album_id,
        number: track.number,
        title: track.title,
        genre_ids: genres.map(&:id),
        track_artists: track_artists
      } }
    end

    assert_equal genres.count, Track.find(JSON.parse(@response.body)['id']).genres.count
    assert_equal track_artists.count, Track.find(JSON.parse(@response.body)['id']).track_artists.count

    assert_response :created
  end

  test 'should show track' do
    get track_url(@track)
    assert_response :success
  end

  test 'should show track with filename for moderator' do
    sign_in_as(create(:moderator))
    get track_url(@track)
    assert_response :success
    body = ActiveSupport::JSON.decode response.body
    assert_equal @track.audio_file&.filename, body['filename']
  end

  test 'should show track without filename for user' do
    get track_url(@track)
    assert_response :success
    body = ActiveSupport::JSON.decode response.body
    assert_nil body['filename']
  end

  test 'user should be able to update review_comment' do
    patch track_url(@track), params: { track: { review_comment: 'comment' } }
    assert_response :success
    @track.reload
    assert_equal 'comment', @track.review_comment
  end

  test 'should not update track metadata for user' do
    patch track_url(@track), params: { track: { album_id: @track.album_id, number: @track.number, title: @track.title } }
    assert_response :success
    @track.reload
    assert_not_equal :album_id, @track.album_id
  end

  test 'should clear review comment' do
    @track.update(review_comment: 'test')
    patch track_url(@track), params: { track: { review_comment: nil } }
    assert_response :success
    @track.reload
    assert_nil @track.review_comment
  end

  test 'should update track for moderator' do
    sign_in_as(create(:moderator))
    track = build(:track, album: @track.album)
    album = create(:album)

    patch track_url(@track), params: { track: { album_id: album.id, number: track.number, title: track.title } }
    assert_response :success
  end

  test 'should not destroy track for user' do
    assert_difference('Track.count', 0) do
      delete track_url(@track)
    end

    assert_response :forbidden
  end

  test 'should destroy track for moderator' do
    sign_in_as(create(:moderator))

    assert_difference('Track.count', -1) do
      delete track_url(@track)
    end

    assert_response :no_content
  end

  test 'should not destroy empty tracks for user' do
    assert_difference('Track.count', 0) do
      post destroy_empty_tracks_url
    end

    assert_response :forbidden
  end

  test 'should destroy empty tracks for moderator' do
    sign_in_as(create(:moderator))

    create :track

    assert_difference('Track.count', -1) do
      post destroy_empty_tracks_url
    end

    assert_response :no_content

    assert_not_nil Track.find_by(id: @track.id)
  end

  test 'should not merge tracks for user' do
    track = create(:track, :with_audio_file)

    assert_difference('Track.count', 0) do
      assert_difference('AudioFile.count', 0) do
        post merge_track_url(@track, other_track_id: track.id)
      end
    end

    assert_response :forbidden
  end

  test 'should merge tracks for moderator' do
    sign_in_as(create(:moderator))
    track = create(:track, :with_audio_file)

    audio_file = track.audio_file

    assert_difference('Track.count', -1) do
      assert_difference('AudioFile.count', -1) do
        post merge_track_url(@track, other_track_id: track.id)
      end
    end

    assert_equal @track, audio_file.reload.track
    assert_equal audio_file.length, JSON.parse(response.body)['length']
    assert_equal audio_file.bitrate, JSON.parse(response.body)['bitrate']

    assert_response :success
  end

  test 'should return not_found if track has no audio' do
    get audio_track_url(create(:track))

    assert_response :not_found
  end

  test 'should return not_found and destroy audio if file is missing ' do
    audio_file = create(:audio_file, filename: '/does-not-exist.flac')

    assert_difference('AudioFile.count', -1) do
      get audio_track_url(create(:track, audio_file: audio_file))
    end

    assert_response :not_found
  end

  test 'should serve audio to user' do
    location = Location.create(path: Rails.root.join('test/files'))
    audio_file = create(:audio_file, location: location, filename: '/base.flac')
    track = create(:track, audio_file: audio_file)

    get audio_track_url(track)

    assert_response :success
  end

  test 'should return not_found if codec_conversion does not exit ' do
    location = Location.create(path: Rails.root.join('test/files'))
    audio_file = create(:audio_file, location: location, filename: '/base.flac')
    track = create(:track, audio_file: audio_file)

    get audio_track_url(track, codec_conversion_id: 0)

    assert_response :not_found
  end

  test 'should create transcoded_item if codec_conversion is present' do
    io = StringIO.new File.read(Rails.root.join('test/files/base.flac'))
    AudioFile.any_instance.stubs(:convert).returns(io)
    mp3 = Codec.create(mimetype: 'audio/mpeg', extension: 'mp3')
    codec_conversion = CodecConversion.create(name: 'MP3 (V0)', ffmpeg_params: '-acodec mp3 -q:a 0', resulting_codec: mp3)
    location = Location.create(path: Rails.root.join('test/files'))
    audio_file = create(:audio_file, location: location, filename: '/base.flac')
    length = audio_file.content_lengths.find_by(codec_conversion: codec_conversion).length
    track = create(:track, audio_file: audio_file)

    assert_difference('TranscodedItem.count', 1) do
      get audio_track_url(track, codec_conversion_id: codec_conversion.id)
    end

    assert_equal length.to_s, response.headers['content-length']
    assert_match 'audio/mpeg', response.headers['content-type']

    assert_response :success
  end

  test 'should not create transcoded_item if it already exists' do
    io = StringIO.new File.read(Rails.root.join('test/files/base.flac'))
    AudioFile.any_instance.stubs(:convert).returns(io)
    codec_conversion = create :codec_conversion
    location = Location.create(path: Rails.root.join('test/files'))
    audio_file = create(:audio_file, location: location, filename: '/base.flac')
    track = create(:track, audio_file: audio_file)
    get audio_track_url(track, codec_conversion_id: codec_conversion.id)

    assert_difference('TranscodedItem.count', 0) do
      get audio_track_url(track, codec_conversion_id: codec_conversion.id)
    end

    assert_response :success
  end

  test 'should return correct headers for  range request' do
    io = StringIO.new File.read(Rails.root.join('test/files/base.flac'))
    AudioFile.any_instance.stubs(:convert).returns(io)
    mp3 = Codec.create(mimetype: 'audio/mpeg', extension: 'mp3')
    codec_conversion = CodecConversion.create(name: 'MP3 (V0)', ffmpeg_params: '-acodec mp3 -q:a 0', resulting_codec: mp3)
    location = Location.create(path: Rails.root.join('test/files'))
    audio_file = create(:audio_file, location: location, filename: '/base.flac')
    length = audio_file.content_lengths.find_by(codec_conversion: codec_conversion).length
    track = create(:track, audio_file: audio_file)

    get(audio_track_url(track, codec_conversion_id: codec_conversion.id), headers: { "range": 'bytes=150-500' })

    assert_equal "bytes 150-500/#{length}", response.headers['content-range']
    assert_equal '351', response.headers['content-length']
    assert_match 'audio/mpeg', response.headers['content-type']

    assert_response :success
  end

  test 'accepts range request without end' do
    io = StringIO.new File.read(Rails.root.join('test/files/base.flac'))
    AudioFile.any_instance.stubs(:convert).returns(io)
    mp3 = Codec.create(mimetype: 'audio/mpeg', extension: 'mp3')
    codec_conversion = CodecConversion.create(name: 'MP3 (V0)', ffmpeg_params: '-acodec mp3 -q:a 0', resulting_codec: mp3)
    location = Location.create(path: Rails.root.join('test/files'))
    audio_file = create(:audio_file, location: location, filename: '/base.flac')
    length = audio_file.content_lengths.find_by(codec_conversion: codec_conversion).length
    track = create(:track, audio_file: audio_file)

    get(audio_track_url(track, codec_conversion_id: codec_conversion.id), headers: { "range": 'bytes=150-' })

    assert_equal "bytes 150-#{length - 1}/#{length}", response.headers['content-range']
    assert_equal (length - 150).to_s, response.headers['content-length']
    assert_match 'audio/mpeg', response.headers['content-type']

    assert_response :success
  end
end
