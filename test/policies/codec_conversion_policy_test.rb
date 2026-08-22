require 'test_helper'

class CodecConversionPolicyTest < ActiveSupport::TestCase
  setup do
    @codec_conversion = create(:codec_conversion)
    @user = create(:user)
    @moderator = create(:moderator)
    @admin = create(:admin)
  end

  test 'policy should not be created for signed-out user' do
    assert_raises Pundit::NotAuthorizedError do
      Pundit.policy!(nil, CodecConversion)
    end
  end

  test 'scope should not be created for signed-out user' do
    assert_raises Pundit::NotAuthorizedError do
      Pundit.policy_scope(nil, CodecConversion)
    end
  end

  test 'all users should see codec conversions' do
    assert_scope_includes @user, @codec_conversion
    assert_scope_includes @moderator, @codec_conversion
    assert_scope_includes @admin, @codec_conversion
  end

  test 'all users should be allowed to access index' do
    assert_permitted @user, CodecConversion, :index
    assert_permitted @moderator, CodecConversion, :index
    assert_permitted @admin, CodecConversion, :index
  end

  test 'all users should be allowed to see a codec conversion' do
    assert_permitted @user, @codec_conversion, :show
    assert_permitted @moderator, @codec_conversion, :show
    assert_permitted @admin, @codec_conversion, :show
  end

  test 'only moderator+ should be allowed to create a codec conversion' do
    assert_not_permitted @user, CodecConversion, :create
    assert_permitted @moderator, CodecConversion, :create
    assert_permitted @admin, CodecConversion, :create
  end

  test 'only moderator+ should be allowed to update a codec conversion' do
    assert_not_permitted @user, @codec_conversion, :update
    assert_permitted @moderator, @codec_conversion, :update
    assert_permitted @admin, @codec_conversion, :update
  end

  test 'only moderator+ should be allowed to destroy a codec conversion' do
    assert_not_permitted @user, @codec_conversion, :destroy
    assert_permitted @moderator, @codec_conversion, :destroy
    assert_permitted @admin, @codec_conversion, :destroy
  end

  test 'moderator+ should be allowed to change all attributes of a codec conversion' do
    assert_no_permitted_attributes @user, @codec_conversion
    assert_attributes_permitted @moderator, @codec_conversion, %i[name ffmpeg_params resulting_codec_id]
    assert_attributes_permitted @admin, @codec_conversion, %i[name ffmpeg_params resulting_codec_id]
  end
end
