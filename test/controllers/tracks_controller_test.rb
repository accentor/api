require 'test_helper'

class TracksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @track = create(:track, :with_audio_file)
    sign_in_as(create(:user))
  end

  test 'should get index with filenames for moderator' do
    expected_etag = construct_etag(Track.order(id: :desc))

    sign_in_as(create(:moderator))
    get tracks_url

    assert_response :success
    assert_equal @track.audio_file.filename, response.parsed_body.dig(0, 'filename')
    assert_equal expected_etag, headers['etag']
  end

  test 'should get index without filenames for user' do
    expected_etag = construct_etag(Track.order(id: :desc))

    get tracks_url

    assert_response :success
    assert_nil response.parsed_body.dig(0, 'filename')
    assert_equal expected_etag, headers['etag']
  end

  test 'should get index and return not modified if etag matches' do
    expected_etag = construct_etag(Track.order(id: :desc))

    get tracks_url, headers: { 'If-None-Match': expected_etag }

    assert_response :not_modified
    assert_empty response.parsed_body
  end

  test 'should get index and include page in etag' do
    expected_etag = construct_etag(Track.order(id: :desc), page: 5, per_page: 501)

    get tracks_url(page: 5, per_page: 501)

    assert_response :success
    assert_equal expected_etag, headers['etag']
  end

  test 'should get index with all genres when filtering by genre' do
    genre = create(:genre)
    @track.update(genres: [genre, create(:genre)])
    expected_etag = construct_etag(Track.by_genre(genre.id).order(id: :desc))

    get tracks_url(genre_id: genre.id)

    assert_response :success
    assert_equal 2, response.parsed_body.dig(0, 'genre_ids').length
    assert_equal expected_etag, headers['etag']
  end

  test 'should not create track for user' do
    assert_difference('Track.count', 0) do
      post tracks_url, params: { track: { album_id: @track.album_id, number: @track.number, title: @track.title } }
    end

    assert_response :forbidden
  end

  test 'should not create track without title' do
    sign_in_as(create(:moderator))
    assert_difference('Track.count', 0) do
      post tracks_url, params: { track: { album_id: @track.album_id, number: @track.number + 1 } }
    end

    assert_response :unprocessable_content
  end

  test 'should not create track without album_id' do
    sign_in_as(create(:moderator))
    assert_difference('Track.count', 0) do
      post tracks_url, params: { track: { number: @track.number + 1, title: 'Title' } }
    end

    assert_response :unprocessable_content
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
        track_artists:
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
  end

  test 'should not update track metadata to empty title' do
    sign_in_as(create(:moderator))
    patch track_url(@track), params: { track: { title: '' } }

    assert_response :unprocessable_content
    @track.reload

    assert_not_equal '', @track.title
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

    create(:track)

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
        post merge_track_url(@track, source_id: track.id)
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
        post merge_track_url(@track, source_id: track.id)
      end
    end

    assert_equal @track, audio_file.reload.track
    assert_equal audio_file.length, response.parsed_body['length']
    assert_equal audio_file.bitrate, response.parsed_body['bitrate']

    assert_response :success
  end

  test 'should return not_found if track has no audio' do
    get audio_track_url(create(:track))

    assert_response :not_found
  end

  test 'should return not_found and destroy audio if file is missing ' do
    audio_file = create(:audio_file, filename: '/does-not-exist.flac')

    assert_difference('AudioFile.count', -1) do
      get audio_track_url(create(:track, audio_file:))
    end

    assert_response :not_found
  end

  test 'should serve audio to user' do
    location = Location.create(path: Rails.root.join('test/files'))
    audio_file = create(:audio_file, location:, filename: '/base.flac')
    track = create(:track, audio_file:)

    get audio_track_url(track)

    assert_response :success
  end

  test 'should download to user' do
    location = Location.create(path: Rails.root.join('test/files'))
    audio_file = create(:audio_file, location:, filename: '/base.flac')
    track = create(:track, audio_file:)

    get download_track_url(track)

    assert_response :success
  end

  class TracksControllerAudioTest < ActionDispatch::IntegrationTest
    setup do
      sign_in_as(create(:user))
      install_audio_file_convert_stub
    end

    teardown do
      uninstall_audio_file_convert_stub
    end

    test 'should return not_found if codec_conversion does not exit ' do
      location = Location.create(path: Rails.root.join('test/files'))
      audio_file = create(:audio_file, location:, filename: '/base.flac')
      track = create(:track, audio_file:)

      get audio_track_url(track, codec_conversion_id: 0)

      assert_response :not_found
    end

    test 'should create transcoded_item if codec_conversion is present' do
      mp3 = Codec.create(mimetype: 'audio/mpeg', extension: 'mp3')
      codec_conversion = CodecConversion.create(name: 'MP3 (V0)', ffmpeg_params: '-acodec mp3 -q:a 0', resulting_codec: mp3)
      location = Location.create(path: Rails.root.join('test/files'))
      flac = Codec.create(mimetype: 'audio/flac', extension: 'flac')
      audio_file = create(:audio_file, location:, filename: '/base.flac', codec: flac)
      perform_enqueued_jobs
      TranscodedItem.destroy_all
      track = create(:track, audio_file:)

      assert_difference('TranscodedItem.count', 1) do
        get audio_track_url(track, codec_conversion_id: codec_conversion.id)
      end

      transcoded_item = TranscodedItem.find_by(audio_file:, codec_conversion:)

      assert_equal File.open(transcoded_item.path, &:size).then(&:to_s), response.headers['content-length']
      assert_match 'audio/mpeg', response.headers['content-type']

      assert_response :success
    end

    test 'should create transcoded_item if it already exists but file is gone' do
      codec_conversion = create(:codec_conversion)
      location = Location.create(path: Rails.root.join('test/files'))
      flac = Codec.create(mimetype: 'audio/flac', extension: 'flac')
      audio_file = create(:audio_file, location:, filename: '/base.flac', codec: flac)
      track = create(:track, audio_file:)
      perform_enqueued_jobs
      transcode = TranscodedItem.find_by(audio_file:, codec_conversion:)
      File.delete(transcode.path)

      assert_difference('TranscodedItem.count', 0) do
        get audio_track_url(track, codec_conversion_id: codec_conversion.id)
      end
      assert_nil TranscodedItem.find_by(id: transcode.id)

      assert_response :success
    end

    test 'should not create transcoded_item if it already exists' do
      codec_conversion = create(:codec_conversion)
      location = Location.create(path: Rails.root.join('test/files'))
      flac = Codec.create(mimetype: 'audio/flac', extension: 'flac')
      audio_file = create(:audio_file, location:, filename: '/base.flac', codec: flac)
      track = create(:track, audio_file:)
      get audio_track_url(track, codec_conversion_id: codec_conversion.id)

      assert_difference('TranscodedItem.count', 0) do
        get audio_track_url(track, codec_conversion_id: codec_conversion.id)
      end

      assert_response :success
    end

    test 'should return correct headers for range request' do
      mp3 = Codec.create(mimetype: 'audio/mpeg', extension: 'mp3')
      codec_conversion = CodecConversion.create(name: 'MP3 (V0)', ffmpeg_params: '-acodec mp3 -q:a 0', resulting_codec: mp3)
      location = Location.create(path: Rails.root.join('test/files'))
      flac = Codec.create(mimetype: 'audio/flac', extension: 'flac')
      audio_file = create(:audio_file, location:, filename: '/base.flac', codec: flac)
      perform_enqueued_jobs
      transcoded_item = TranscodedItem.find_by(audio_file:, codec_conversion:)
      length = File.open(transcoded_item.path, &:size)
      track = create(:track, audio_file:)

      get(audio_track_url(track, codec_conversion_id: codec_conversion.id), headers: { range: 'bytes=150-500' })

      assert_equal "bytes 150-500/#{length}", response.headers['content-range']
      assert_equal '351', response.headers['content-length']
      assert_match 'audio/mpeg', response.headers['content-type']

      assert_response :success
    end

    test 'accepts range request without end' do
      mp3 = Codec.create(mimetype: 'audio/mpeg', extension: 'mp3')
      codec_conversion = CodecConversion.create(name: 'MP3 (V0)', ffmpeg_params: '-acodec mp3 -q:a 0', resulting_codec: mp3)
      location = Location.create(path: Rails.root.join('test/files'))
      flac = Codec.create(mimetype: 'audio/flac', extension: 'flac')
      audio_file = create(:audio_file, location:, filename: '/base.flac', codec: flac)
      perform_enqueued_jobs
      transcoded_item = TranscodedItem.find_by(audio_file:, codec_conversion:)
      length = File.open(transcoded_item.path, &:size)
      track = create(:track, audio_file:)

      get(audio_track_url(track, codec_conversion_id: codec_conversion.id), headers: { range: 'bytes=150-' })

      assert_equal "bytes 150-#{length - 1}/#{length}", response.headers['content-range']
      assert_equal (length - 150).to_s, response.headers['content-length']
      assert_match 'audio/mpeg', response.headers['content-type']

      assert_response :success
    end
  end
end
