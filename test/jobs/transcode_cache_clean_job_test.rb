require 'test_helper'

class TranscodeCacheCleanJobTest < ActiveJob::TestCase
  test 'Transcode cache clean should remove old transcodes' do
    io = StringIO.new Rails.root.join('test/files/base.flac').read
    AudioFile.any_instance.stubs(:convert).returns(io)
    5.times { create(:transcoded_item, last_used: 2.days.ago) }
    3.times { create(:transcoded_item, last_used: 1.hour.ago) }
    assert_difference('TranscodedItem.count', -5) do
      TranscodeCacheCleanJob.perform_now
    end
  end
end
