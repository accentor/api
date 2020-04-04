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
    a1 = create(:track, :with_audio_file)
    a2 = create(:track, :with_audio_file)

    a1.merge(a2)

    assert_equal 1, AudioFile.count
  end

  test 'should be able to merge two tracks with one resulting audio_file' do
    a1 = create(:track)
    a2 = create(:track, :with_audio_file)

    a1.merge(a2)

    assert_equal 1, AudioFile.count
    assert a1.reload.audio_file.present?
  end

  test 'should be able to merge two tracks with zero resulting audio_files' do
    a1 = create(:track, :with_audio_file)
    a2 = create(:track)

    a1.merge(a2)

    assert_equal 0, AudioFile.count
    assert a1.reload.audio_file.blank?
  end

  test 'should be able to merge two tracks with zero starting audio_files' do
    a1 = create(:track)
    a2 = create(:track)

    a1.merge(a2)

    assert_equal 0, AudioFile.count
    assert a1.reload.audio_file.blank?
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
end
