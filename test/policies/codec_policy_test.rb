require 'test_helper'

class CodecPolicyTest < ActiveSupport::TestCase
  setup do
    @codec = create(:codec)
    @user = create(:user)
    @moderator = create(:moderator)
    @admin = create(:admin)
  end

  test 'policy should not be created for signed-out user' do
    assert_raises Pundit::NotAuthorizedError do
      Pundit.policy!(nil, Codec)
    end
  end

  test 'scope should not be created for signed-out user' do
    assert_raises Pundit::NotAuthorizedError do
      Pundit.policy_scope(nil, Codec)
    end
  end

  test 'all users should see codecs' do
    assert_scope_includes @user, @codec
    assert_scope_includes @moderator, @codec
    assert_scope_includes @admin, @codec
  end

  test 'all users should be allowed to access index' do
    assert_permitted @user, Codec, :index
    assert_permitted @moderator, Codec, :index
    assert_permitted @admin, Codec, :index
  end

  test 'all users should be allowed to see a codec' do
    assert_permitted @user, @codec, :show
    assert_permitted @moderator, @codec, :show
    assert_permitted @admin, @codec, :show
  end

  test 'only moderator+ should be allowed to create a codec' do
    assert_not_permitted @user, Codec, :create
    assert_permitted @moderator, Codec, :create
    assert_permitted @admin, Codec, :create
  end

  test 'only moderator+ should be allowed to update a codec' do
    assert_not_permitted @user, @codec, :update
    assert_permitted @moderator, @codec, :update
    assert_permitted @admin, @codec, :update
  end

  test 'only moderator+ should be allowed to destroy a codec' do
    assert_not_permitted @user, @codec, :destroy
    assert_permitted @moderator, @codec, :destroy
    assert_permitted @admin, @codec, :destroy
  end

  test 'moderator+ should be allowed to set all attributes of a new codec' do
    assert_no_permitted_attributes @user, CodecConversion, :create
    assert_attributes_permitted @moderator, CodecConversion, %i[mimetype extension], :create
    assert_attributes_permitted @admin, CodecConversion, %i[mimetype extension], :create
  end

  test 'moderator+ should be allowed to change the mimetype of a codec' do
    assert_no_permitted_attributes @user, @codec_conversion, :update
    assert_attributes_permitted @moderator, @codec_conversion, %i[mimetype], :update
    assert_attributes_permitted @admin, @codec_conversion, %i[mimetype], :update
  end
end
