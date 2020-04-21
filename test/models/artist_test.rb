# == Schema Information
#
# Table name: artists
#
#  id              :bigint           not null, primary key
#  name            :string           not null
#  normalized_name :string           not null
#  review_comment  :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  image_id        :bigint
#

require 'test_helper'

class ArtistTest < ActiveSupport::TestCase
  test 'should automatically generate normalized_name' do
    artist = build(:artist, name: 'ïóùåAÁ')
    artist.save
    assert_not artist.normalized_name.nil?
    assert_equal 'iouaaa', artist.normalized_name
  end

  test 'should be able to search by id' do
    a1 = create(:artist)
    a2 = create(:artist)
    a3 = create(:artist)

    assert_equal [a1], Artist.by_ids(a1.id).to_a
    assert_equal [a1, a2], Artist.by_ids([a1.id, a2.id]).to_a
    assert_equal [a3], Artist.by_ids(a3.id).to_a
  end
end
