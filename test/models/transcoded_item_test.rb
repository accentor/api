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
# Indexes
#
#  index_transcoded_items_on_audio_file_id                          (audio_file_id)
#  index_transcoded_items_on_audio_file_id_and_codec_conversion_id  (audio_file_id,codec_conversion_id) UNIQUE
#  index_transcoded_items_on_codec_conversion_id                    (codec_conversion_id)
#  index_transcoded_items_on_codec_conversion_id_and_uuid           (codec_conversion_id,uuid) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (audio_file_id => audio_files.id)
#  fk_rails_...  (codec_conversion_id => codec_conversions.id)
#
require 'test_helper'

class TranscodedItemTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
