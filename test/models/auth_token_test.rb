# == Schema Information
#
# Table name: auth_tokens
#
#  id          :bigint           not null, primary key
#  application :string
#  user_agent  :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  device_id   :string           not null
#  user_id     :bigint           not null
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
  test 'auth_token should have device_id after creation' do
    user = create(:user)
    a = AuthToken.create(user:, user_agent: '')

    assert_not_nil a.device_id
  end
end
