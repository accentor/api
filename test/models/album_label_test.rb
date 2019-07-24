# == Schema Information
#
# Table name: album_labels
#
#  id               :bigint           not null, primary key
#  album_id         :bigint           not null
#  label_id         :bigint           not null
#  catalogue_number :string           not null
#

require 'test_helper'

class AlbumLabelTest < ActiveSupport::TestCase
end
