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
    assert t1.reload.audio_file.present?
    assert_equal 1, Track.count
  end

  test 'merging a track with no audio_file should not change audio_file' do
    t1 = create(:track, :with_audio_file)
    t2 = create(:track)

    t1.merge(t2)

    assert_equal 1, AudioFile.count
    assert t1.reload.audio_file.present?
    assert_equal 1, Track.count
  end

  test 'should be able to merge two tracks with zero starting audio_files' do
    t1 = create(:track)
    t2 = create(:track)

    t1.merge(t2)

    assert_equal 0, AudioFile.count
    assert t1.reload.audio_file.blank?
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
    assert_equal [t1, t2], Track.by_genre(g2.id).to_a
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
end
