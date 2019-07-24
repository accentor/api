# == Schema Information
#
# Table name: audio_files
#
#  id          :bigint           not null, primary key
#  location_id :bigint           not null
#  codec_id    :bigint           not null
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
