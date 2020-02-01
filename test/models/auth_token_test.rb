# == Schema Information
#
# Table name: auth_tokens
#
#  id            :bigint           not null, primary key
#  hashed_secret :string           not null
#  user_agent    :string           not null
#  device_id     :string           not null
#  user_id       :bigint           not null
#
# Indexes
#
#  index_auth_tokens_on_device_id  (device_id) UNIQUE
#  index_auth_tokens_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

require 'test_helper'

class AuthTokenTest < ActiveSupport::TestCase
  test 'auth_token should have secret after creation' do
    user = create(:user)
    a = AuthToken.create(user: user, user_agent: '')
    assert_not_nil a.secret
  end

  test 'auth_token should not have secret when fetched from database' do
    create(:auth_token)
    assert_nil AuthToken.first.secret
  end
end
