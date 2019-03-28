# == Schema Information
#
# Table name: codec_conversions
#
#  id                 :bigint(8)        not null, primary key
#  name               :string           not null
#  ffmpeg_params      :string           not null
#  resulting_codec_id :bigint(8)        not null
#

require 'test_helper'

class CodecConversionTest < ActiveSupport::TestCase
end
