require 'test_helper'

class CodecConversionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @codec_conversion = create(:codec_conversion)
    sign_in_as(create(:user))
  end

  test 'should get index' do
    get codec_conversions_url
    assert_response :success
  end

  test 'should filter by codec' do
    create(:codec_conversion)
    get codec_conversions_url(codec: @codec_conversion.resulting_codec)

    assert_equal 1, JSON.parse(@response.body).count
    assert_response :success
  end

  test 'should not create codec_conversion for user' do
    codec_conversion = build(:codec_conversion)
    assert_difference('CodecConversion.count', 0) do
      post codec_conversions_url, params: { codec_conversion: {
        ffmpeg_params: codec_conversion.ffmpeg_params,
        name: codec_conversion.name,
        resulting_codec_id: codec_conversion.resulting_codec_id
      } }
    end

    assert_response :unauthorized
  end

  test 'should create codec_conversion for moderator' do
    sign_in_as(create(:moderator))
    codec_conversion = build(:codec_conversion, resulting_codec: create(:codec))
    assert_difference('CodecConversion.count', 1) do
      post codec_conversions_url, params: { codec_conversion: {
        ffmpeg_params: codec_conversion.ffmpeg_params,
        name: codec_conversion.name,
        resulting_codec_id: codec_conversion.resulting_codec_id
      } }
    end

    assert_response :created
  end

  test 'should create codec_conversion for admin' do
    sign_in_as(create(:admin))
    codec_conversion = build(:codec_conversion, resulting_codec: create(:codec))
    assert_difference('CodecConversion.count', 1) do
      post codec_conversions_url, params: { codec_conversion: {
        ffmpeg_params: codec_conversion.ffmpeg_params,
        name: codec_conversion.name,
        resulting_codec_id: codec_conversion.resulting_codec_id
      } }
    end

    assert_response :created
  end

  test 'should show codec_conversion' do
    get codec_conversion_url(@codec_conversion)
    assert_response :success
  end

  test 'should not update codec_conversion for user' do
    patch codec_conversion_url(@codec_conversion), params: { codec_conversion: {
      ffmpeg_params: @codec_conversion.ffmpeg_params,
      name: @codec_conversion.name,
      resulting_codec_id: @codec_conversion.resulting_codec_id
    } }
    assert_response :unauthorized
  end

  test 'should update codec_conversion for moderator' do
    sign_in_as(create(:moderator))
    patch codec_conversion_url(@codec_conversion), params: { codec_conversion: {
      ffmpeg_params: @codec_conversion.ffmpeg_params,
      name: @codec_conversion.name,
      resulting_codec_id: @codec_conversion.resulting_codec_id
    } }
    assert_response :success
  end

  test 'should update codec_conversion for admin' do
    sign_in_as(create(:admin))
    patch codec_conversion_url(@codec_conversion), params: { codec_conversion: {
      ffmpeg_params: @codec_conversion.ffmpeg_params,
      name: @codec_conversion.name,
      resulting_codec_id: @codec_conversion.resulting_codec_id
    } }
    assert_response :success
  end

  test 'should not destroy codec_conversion for user' do
    assert_difference('CodecConversion.count', 0) do
      delete codec_conversion_url(@codec_conversion)
    end

    assert_response :unauthorized
  end

  test 'should destroy codec_conversion for moderator' do
    sign_in_as(create(:moderator))
    assert_difference('CodecConversion.count', -1) do
      delete codec_conversion_url(@codec_conversion)
    end

    assert_response :no_content
  end

  test 'should destroy codec_conversion for admin' do
    sign_in_as(create(:admin))
    assert_difference('CodecConversion.count', -1) do
      delete codec_conversion_url(@codec_conversion)
    end

    assert_response :no_content
  end
end
