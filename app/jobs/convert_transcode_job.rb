class ConvertTranscodeJob < ApplicationJob
  queue_as :transcodes
  queue_with_priority 5

  def perform(transcode)
    transcode.do_conversion
  end
end
