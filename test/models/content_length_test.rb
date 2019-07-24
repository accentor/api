# == Schema Information
#
# Table name: content_lengths
#
#  id                  :bigint           not null, primary key
#  audio_file_id       :bigint           not null
#  codec_conversion_id :bigint           not null
#  length              :integer          not null
#

require 'test_helper'

class ContentLengthTest < ActiveSupport::TestCase
end
