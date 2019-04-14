# == Schema Information
#
# Table name: audio_files
#
#  id          :bigint(8)        not null, primary key
#  location_id :bigint(8)        not null
#  codec_id    :bigint(8)        not null
#  filename    :string           not null
#  length      :integer          not null
#  bitrate     :integer          not null
#

require 'test_helper'

class AudioFileTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
