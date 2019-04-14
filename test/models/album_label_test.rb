# == Schema Information
#
# Table name: album_labels
#
#  id               :bigint(8)        not null, primary key
#  album_id         :bigint(8)        not null
#  label_id         :bigint(8)        not null
#  catalogue_number :string           not null
#

require 'test_helper'

class AlbumLabelTest < ActiveSupport::TestCase
end
