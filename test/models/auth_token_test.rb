# == Schema Information
#
# Table name: auth_tokens
#
#  id            :bigint           not null, primary key
#  application   :string
#  hashed_secret :string           not null
#  user_agent    :string           not null
#  device_id     :string           not null
#  user_id       :bigint           not null
#

require 'test_helper'

class AuthTokenTest < ActiveSupport::TestCase
  test 'auth_token should have secret after creation' do
    user = create(:user)
    a = AuthToken.create(user:, user_agent: '')

    assert_not_nil a.secret
  end

  test 'auth_token should not have secret when fetched from database' do
    create(:auth_token)

    assert_nil AuthToken.first.secret
  end
end
