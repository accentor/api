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
# Indexes
#
#  index_audio_files_on_codec_id                  (codec_id)
#  index_audio_files_on_location_id               (location_id)
#  index_audio_files_on_location_id_and_filename  (location_id,filename) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (codec_id => codecs.id)
#  fk_rails_...  (location_id => locations.id)
#

require 'test_helper'

class AudioFileTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
