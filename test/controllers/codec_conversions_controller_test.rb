require 'test_helper'

class CodecConversionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @codec_conversion = create(:codec_conversion)
    sign_in_as(create(:user))
  end

  test 'should get index' do
    expected_etag = construct_etag(CodecConversion.order(id: :asc))

    get codec_conversions_url

    assert_response :success
    assert_equal expected_etag, headers['etag']
  end

  test 'should get index and return not modified if etag matches' do
    expected_etag = construct_etag(CodecConversion.order(id: :asc))

    get codec_conversions_url, headers: { 'If-None-Match': expected_etag }

    assert_response :not_modified
    assert_empty response.parsed_body
  end

  test 'should get index and include page in etag' do
    expected_etag = construct_etag(CodecConversion.order(id: :asc), page: 5, per_page: 501)

    get codec_conversions_url(page: 5, per_page: 501)

    assert_response :success
    assert_equal expected_etag, headers['etag']
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

    assert_response :forbidden
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

  test 'should not create duplicate codec_conversion' do
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

    assert_difference('CodecConversion.count', 0) do
      post codec_conversions_url, params: { codec_conversion: {
        ffmpeg_params: codec_conversion.ffmpeg_params,
        name: codec_conversion.name,
        resulting_codec_id: codec_conversion.resulting_codec_id
      } }
    end

    assert_response :unprocessable_content
  end

  test 'should not create codec_conversion with empty ffmpeg_params' do
    sign_in_as(create(:moderator))
    codec_conversion = build(:codec_conversion, resulting_codec: create(:codec))
    assert_difference('CodecConversion.count', 0) do
      post codec_conversions_url, params: { codec_conversion: {
        name: codec_conversion.name,
        resulting_codec_id: codec_conversion.resulting_codec_id
      } }
    end

    assert_response :unprocessable_content
  end

  test 'should not create codec_conversion with empty name' do
    sign_in_as(create(:moderator))
    codec_conversion = build(:codec_conversion, resulting_codec: create(:codec))
    assert_difference('CodecConversion.count', 0) do
      post codec_conversions_url, params: { codec_conversion: {
        ffmpeg_params: codec_conversion.ffmpeg_params,
        resulting_codec_id: codec_conversion.resulting_codec_id
      } }
    end

    assert_response :unprocessable_content
  end

  test 'should not create codec_conversion with non-existing resulting_codec' do
    sign_in_as(create(:moderator))
    codec_conversion = build(:codec_conversion, resulting_codec: create(:codec))
    assert_difference('CodecConversion.count', 0) do
      post codec_conversions_url, params: { codec_conversion: {
        ffmpeg_params: codec_conversion.ffmpeg_params,
        name: codec_conversion.name,
        resulting_codec_id: codec_conversion.resulting_codec_id + 1
      } }
    end

    assert_response :unprocessable_content
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

    assert_response :forbidden
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

  test 'should not update codec_conversion to empty name' do
    sign_in_as(create(:moderator))
    patch codec_conversion_url(@codec_conversion), params: { codec_conversion: {
      name: ''
    } }

    assert_response :unprocessable_content
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

    assert_response :forbidden
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
