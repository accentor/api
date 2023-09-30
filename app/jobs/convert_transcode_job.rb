class ConvertTranscodeJob < ApplicationJob
  queue_as :within_30_seconds

  def perform(transcode)
    transcode.do_conversion
  end
end
