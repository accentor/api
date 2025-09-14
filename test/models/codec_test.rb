# == Schema Information
#
# Table name: codecs
#
#  id         :bigint           not null, primary key
#  extension  :string           not null
#  mimetype   :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_codecs_on_extension  (extension) UNIQUE
#

require 'test_helper'

class CodecTest < ActiveSupport::TestCase
end
