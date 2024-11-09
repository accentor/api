# == Schema Information
#
# Table name: tracks
#
#  id               :bigint           not null, primary key
#  normalized_title :string           not null
#  number           :integer          not null
#  review_comment   :string
#  title            :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  album_id         :bigint           not null
#  audio_file_id    :bigint
#
# Indexes
#
#  index_tracks_on_album_id          (album_id)
#  index_tracks_on_audio_file_id     (audio_file_id) UNIQUE
#  index_tracks_on_normalized_title  (normalized_title)
#
# Foreign Keys
#
#  fk_rails_...  (album_id => albums.id)
#  fk_rails_...  (audio_file_id => audio_files.id)
#

require 'test_helper'

class TrackTest < ActiveSupport::TestCase
  test 'should be able to merge two tracks with two starting audio_files' do
    t1 = create(:track, :with_audio_file)
    t2 = create(:track, :with_audio_file)
    audio_file_id = t2.audio_file.id

    t1.merge(t2)

    assert_equal 1, AudioFile.count
    assert_equal audio_file_id, t1.reload.audio_file.id
    assert_equal 1, Track.count
  end

  test 'should be able to merge two tracks with one resulting audio_file' do
    t1 = create(:track)
    t2 = create(:track, :with_audio_file)

    t1.merge(t2)

    assert_equal 1, AudioFile.count
    assert_predicate t1.reload.audio_file, :present?
    assert_equal 1, Track.count
  end

  test 'merging a track with no audio_file should not change audio_file' do
    t1 = create(:track, :with_audio_file)
    t2 = create(:track)

    t1.merge(t2)

    assert_equal 1, AudioFile.count
    assert_predicate t1.reload.audio_file, :present?
    assert_equal 1, Track.count
  end

  test 'should be able to merge two tracks with zero starting audio_files' do
    t1 = create(:track)
    t2 = create(:track)

    t1.merge(t2)

    assert_equal 0, AudioFile.count
    assert_predicate t1.reload.audio_file, :blank?
    assert_equal 1, Track.count
  end

  test 'should move plays on merge' do
    t1 = create(:track)
    t2 = create(:track)
    create(:play, track: t2)

    assert_no_difference('Play.count') do
      t1.merge(t2)
    end

    assert_equal 1, Track.count
    assert_equal 1, t1.plays.count
  end

  test 'should move playlist_items on merge' do
    t1 = create(:track)
    t2 = create(:track)
    create(:playlist_item, item: t2)

    assert_no_difference('PlaylistItem.count') do
      t1.merge(t2)
    end

    assert_equal 1, Track.count
    assert_equal 1, t1.playlist_items.count
  end

  test 'should be able to destroy track with genres' do
    g1 = create(:genre)
    g2 = create(:genre)
    track = create(:track, genres: [g1, g2])

    assert track.destroy
    assert_equal 0, Track.count
  end

  test 'should be able to search by genre' do
    t1 = create(:track)
    t2 = create(:track)

    g1 = create(:genre)
    g2 = create(:genre)
    g3 = create(:genre)

    t1.update(genres: [g1, g2])
    t2.update(genres: [g2, g3])

    assert_equal [t1], Track.by_genre(g1.id).to_a
    assert_includes Track.by_genre(g2.id).to_a, t1
    assert_includes Track.by_genre(g2.id).to_a, t2
    assert_equal [t2], Track.by_genre(g3.id).to_a
  end

  test 'should automatically generate normalized_title' do
    track = build(:track, title: 'ïóùåAÁ')
    track.save

    assert_not track.normalized_title.nil?
    assert_equal 'iouaaa', track.normalized_title
  end

  test 'should normalize order of track artists' do
    ta1 = build(:track_artist, order: 5)
    ta2 = build(:track_artist, order: 2)
    track = build(:track, track_artists: [ta1, ta2])
    track.save

    assert_equal 2, ta1.order
    assert_equal 1, ta2.order
  end

  test 'should leave order of track artists alone if normalized' do
    ta1 = build(:track_artist, order: 1)
    ta2 = build(:track_artist, order: 2)
    track = build(:track, track_artists: [ta1, ta2])
    track.save

    assert_equal 1, ta1.order
    assert_equal 2, ta2.order
  end

  test 'should normalize order of track artists in order provided if equal' do
    ta1 = build(:track_artist, order: 0)
    ta2 = build(:track_artist, order: 0)
    track = build(:track, track_artists: [ta1, ta2])
    track.save

    assert_equal 1, ta1.order
    assert_equal 2, ta2.order
  end

  test 'should nilify blank review_comment' do
    track = build(:track, review_comment: '')
    track.save

    assert_nil track.review_comment
  end

  test 'should be able to merge tracks if one belongs to playlist' do
    track1 = create(:track)
    track2 = create(:track)
    playlist = create(:playlist, playlist_type: :track)
    create(:playlist_item, item: track1, playlist:)

    assert_difference('Track.count', -1) do
      track2.merge(track1)
    end

    assert_not playlist.reload.item_ids.include? track1.id
    assert_includes playlist.reload.item_ids, track2.id
  end

  test 'should be able to merge tracks if they belong to the same playlist' do
    track1 = create(:track)
    track2 = create(:track)
    playlist = create(:playlist, playlist_type: :track)
    create(:playlist_item, item: track1, playlist:)
    create(:playlist_item, item: track2, playlist:)

    assert_difference(['Track.count', 'PlaylistItem.count'], -1) do
      track2.merge(track1)
    end

    assert_not playlist.reload.item_ids.include? track1.id
    assert_includes playlist.reload.item_ids, track2.id
  end
end
