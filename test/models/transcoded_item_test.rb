# == Schema Information
#
# Table name: transcoded_items
#
#  id                  :bigint           not null, primary key
#  uuid                :string           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  audio_file_id       :bigint           not null
#  codec_conversion_id :bigint           not null
#
require 'test_helper'

class TranscodedItemTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
