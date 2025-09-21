require 'test_helper'

class ImageTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @image_type = create(:image_type)
    sign_in_as(create(:user))
  end

  test 'should get index' do
    expected_etag = construct_etag(ImageType.order(id: :asc))

    get image_types_url

    assert_response :success
    assert_equal expected_etag, headers['etag']
  end

  test 'should get index and return not modified if etag matches' do
    expected_etag = construct_etag(ImageType.order(id: :asc))

    get image_types_url, headers: { 'If-None-Match': expected_etag }

    assert_response :not_modified
    assert_empty response.parsed_body
  end

  test 'should get index and include page in etag' do
    expected_etag = construct_etag(ImageType.order(id: :asc), page: 5, per_page: 501)

    get image_types_url(page: 5, per_page: 501)

    assert_response :success
    assert_equal expected_etag, headers['etag']
  end

  test 'should not create image_type for user' do
    image_type = build(:image_type)
    assert_difference('ImageType.count', 0) do
      post image_types_url, params: { image_type: { extension: image_type.extension, mimetype: image_type.mimetype } }
    end

    assert_response :forbidden
  end

  test 'should not create image_type without extension' do
    sign_in_as(create(:moderator))
    image_type = build(:image_type)
    assert_difference('ImageType.count', 0) do
      post image_types_url, params: { image_type: { mimetype: image_type.mimetype } }
    end

    assert_response :unprocessable_content
  end

  test 'should not create image_type without mimetype' do
    sign_in_as(create(:moderator))
    image_type = build(:image_type)
    assert_difference('ImageType.count', 0) do
      post image_types_url, params: { image_type: { extension: image_type.extension } }
    end

    assert_response :unprocessable_content
  end

  test 'should create image_type for moderator' do
    sign_in_as(create(:moderator))
    image_type = build(:image_type)
    assert_difference('ImageType.count', 1) do
      post image_types_url, params: { image_type: { extension: image_type.extension, mimetype: image_type.mimetype } }
    end

    assert_response :created
  end

  test 'should create image_type for admin' do
    sign_in_as(create(:admin))
    image_type = build(:image_type)
    assert_difference('ImageType.count', 1) do
      post image_types_url, params: { image_type: { extension: image_type.extension, mimetype: image_type.mimetype } }
    end

    assert_response :created
  end

  test 'should show image_type' do
    get image_type_url(@image_type)

    assert_response :success
  end

  test 'should not update image_type for user' do
    patch image_type_url(@image_type), params: { image_type: { mimetype: @image_type.mimetype } }

    assert_response :forbidden
  end

  test 'should not update image_type to empty mimetype' do
    sign_in_as(create(:moderator))
    patch image_type_url(@image_type), params: { image_type: { mimetype: '' } }

    assert_response :unprocessable_content
    @image_type.reload

    assert_not_equal '', @image_type.mimetype
  end

  test 'should update image_type for moderator' do
    sign_in_as(create(:moderator))
    patch image_type_url(@image_type), params: { image_type: { mimetype: @image_type.mimetype } }

    assert_response :success
  end

  test 'should update image_type for admin' do
    sign_in_as(create(:admin))
    patch image_type_url(@image_type), params: { image_type: { mimetype: @image_type.mimetype } }

    assert_response :success
  end

  test 'should not destroy image_type for user' do
    assert_difference('ImageType.count', 0) do
      delete image_type_url(@image_type)
    end

    assert_response :forbidden
  end

  test 'should destroy image_type for moderator' do
    sign_in_as(create(:moderator))
    assert_difference('ImageType.count', -1) do
      delete image_type_url(@image_type)
    end

    assert_response :no_content
  end

  test 'should destroy image_type for admin' do
    sign_in_as(create(:admin))
    assert_difference('ImageType.count', -1) do
      delete image_type_url(@image_type)
    end

    assert_response :no_content
  end
end
