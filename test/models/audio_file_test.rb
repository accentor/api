# == Schema Information
#
# Table name: audio_files
#
#  id          :bigint           not null, primary key
#  bitrate     :integer          not null
#  filename    :string           not null
#  length      :integer          not null
#  codec_id    :bigint           not null
#  location_id :bigint           not null
#

require 'test_helper'

class AudioFileTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
