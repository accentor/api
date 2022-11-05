require 'test_helper'

class CodecsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @codec = create(:codec)
    sign_in_as(create(:user))
  end

  test 'should get index' do
    get codecs_url

    assert_response :success
  end

  test 'should not create codec for user' do
    codec = build(:codec)
    assert_difference('Codec.count', 0) do
      post codecs_url, params: { codec: { extension: codec.extension, mimetype: codec.mimetype } }
    end

    assert_response :forbidden
  end

  test 'should not create codec with missing extension' do
    sign_in_as(create(:moderator))
    codec = build(:codec)
    assert_difference('Codec.count', 0) do
      post codecs_url, params: { codec: { mimetype: codec.mimetype } }
    end

    assert_response :unprocessable_entity
  end

  test 'should not create codec with missing mimetype' do
    sign_in_as(create(:moderator))
    codec = build(:codec)
    assert_difference('Codec.count', 0) do
      post codecs_url, params: { codec: { extension: codec.extension } }
    end

    assert_response :unprocessable_entity
  end

  test 'should create codec for moderator' do
    sign_in_as(create(:moderator))
    codec = build(:codec)
    assert_difference('Codec.count', 1) do
      post codecs_url, params: { codec: { extension: codec.extension, mimetype: codec.mimetype } }
    end

    assert_response :created
  end

  test 'should create codec for admin' do
    sign_in_as(create(:admin))
    codec = build(:codec)
    assert_difference('Codec.count', 1) do
      post codecs_url, params: { codec: { extension: codec.extension, mimetype: codec.mimetype } }
    end

    assert_response :created
  end

  test 'should show codec' do
    get codec_url(@codec)

    assert_response :success
  end

  test 'should not update codec for user' do
    patch codec_url(@codec), params: { codec: { mimetype: @codec.mimetype } }

    assert_response :forbidden
  end

  test 'should not update codec when clearing mimetype' do
    sign_in_as(create(:moderator))
    patch codec_url(@codec), params: { codec: { mimetype: '' } }

    assert_response :unprocessable_entity
  end

  test 'should update codec for moderator' do
    sign_in_as(create(:moderator))
    patch codec_url(@codec), params: { codec: { mimetype: @codec.mimetype } }

    assert_response :success
  end

  test 'should update codec for admin' do
    sign_in_as(create(:admin))
    patch codec_url(@codec), params: { codec: { mimetype: @codec.mimetype } }

    assert_response :success
  end

  test 'should not destroy codec for user' do
    assert_difference('Codec.count', 0) do
      delete codec_url(@codec)
    end

    assert_response :forbidden
  end

  test 'should destroy codec for moderator' do
    sign_in_as(create(:moderator))
    assert_difference('Codec.count', -1) do
      delete codec_url(@codec)
    end

    assert_response :no_content
  end

  test 'should destroy codec for admin' do
    sign_in_as(create(:admin))
    assert_difference('Codec.count', -1) do
      delete codec_url(@codec)
    end

    assert_response :no_content
  end
end
