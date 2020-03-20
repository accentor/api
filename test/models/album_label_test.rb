# == Schema Information
#
# Table name: album_labels
#
#  id               :bigint           not null, primary key
#  catalogue_number :string
#  album_id         :bigint           not null
#  label_id         :bigint           not null
#

require 'test_helper'

class AlbumLabelTest < ActiveSupport::TestCase
end
