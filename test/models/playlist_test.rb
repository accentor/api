# == Schema Information
#
# Table name: playlists
#
#  id            :bigint           not null, primary key
#  description   :string           not null
#  name          :string           not null
#  playlist_type :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :bigint
#
require 'test_helper'

class PlaylistTest < ActiveSupport::TestCase
  test 'should have name' do
    list = build(:playlist, name: '')
    assert_not_predicate list, valid?
    assert_not_empty list.errors[:name]
  end
end
