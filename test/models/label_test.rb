# == Schema Information
#
# Table name: labels
#
#  id              :bigint           not null, primary key
#  name            :string           not null
#  normalized_name :string           not null
#

require 'test_helper'

class LabelTest < ActiveSupport::TestCase
  test 'should automatically generate normalized_name' do
    label = build(:label, name: 'ïóùåAÁ')
    label.save
    assert_not label.normalized_name.nil?
    assert_equal 'iouaaa', label.normalized_name
  end

  test 'should be able to merge label' do
    label1 = create(:label)
    label2 = create(:label)

    assert_difference('Label.count', -1) do
      label2.merge(label1)
    end
  end

  test 'should be able to merge labels if one belongs to album' do
    label1 = create(:label)
    label2 = create(:label)
    album = create(:album)
    al1 = create(:album_label, album: album, label: label1)

    assert_difference('Label.count', -1) do
      label2.merge(label1)
    end
    assert_not album.reload.labels.include?(label1)
    assert album.reload.labels.include?(label2)
  end

  test 'should be able to merge labels if track belongs to both' do
    label1 = create(:label)
    label2 = create(:label)
    album = create(:album)
    al1 = create(:album_label, album: album, label: label1)
    al2 = create(:album_label, album: album, label: label2)

    assert_difference('Label.count', -1) do
      label2.merge(label1)
    end
    assert_not album.reload.labels.include?(label1)
    assert album.reload.labels.include?(label2)
  end
end
