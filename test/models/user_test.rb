# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  name            :string           not null
#  password_digest :string           not null
#  permission      :integer          default("0"), not null
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
end
