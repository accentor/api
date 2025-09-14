# == Schema Information
#
# Table name: codec_conversions
#
#  id                 :bigint           not null, primary key
#  ffmpeg_params      :string           not null
#  name               :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  resulting_codec_id :bigint           not null
#
# Indexes
#
#  index_codec_conversions_on_name                (name) UNIQUE
#  index_codec_conversions_on_resulting_codec_id  (resulting_codec_id)
#
# Foreign Keys
#
#  fk_rails_...  (resulting_codec_id => codecs.id)
#

require 'test_helper'

class CodecConversionTest < ActiveSupport::TestCase
  setup do
    @codec_conversion = create(:codec_conversion)
    create_list(:transcoded_item, 5, codec_conversion: @codec_conversion)
  end

  test 'destroying a codec conversion deletes all files and transcoded_items' do
    FileUtils.stubs(:rm_rf).once.with(File.join(TranscodedItem::BASE_PATH, @codec_conversion.id.to_s))

    assert_difference('TranscodedItem.count', -5) do
      @codec_conversion.destroy
    end
  end

  test 'changing a codec conversion deletes all files and transcoded_items and schedules a new job' do
    FileUtils.stubs(:rm_rf).once.with(File.join(TranscodedItem::BASE_PATH, @codec_conversion.id.to_s))

    assert_enqueued_jobs 1 do
      assert_difference('TranscodedItem.count', -5) do
        @codec_conversion.update!(ffmpeg_params: '-acodec mp3')
      end
    end
  end
end
