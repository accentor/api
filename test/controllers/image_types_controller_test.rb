require 'test_helper'

class ImageTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @image_type = create(:image_type)
    sign_in_as(create(:user))
  end

  test 'should get index' do
    get image_types_url
    assert_response :success
  end

  test 'should not create image_type for user' do
    image_type = build(:image_type)
    assert_difference('ImageType.count', 0) do
      post image_types_url, params: {image_type: {extension: image_type.extension, mimetype: image_type.mimetype}}
    end

    assert_response :unauthorized
  end

  test 'should create image_type for moderator' do
    sign_in_as(create(:moderator))
    image_type = build(:image_type)
    assert_difference('ImageType.count', 1) do
      post image_types_url, params: {image_type: {extension: image_type.extension, mimetype: image_type.mimetype}}
    end

    assert_response :created
  end

  test 'should show image_type' do
    get image_type_url(@image_type)
    assert_response :success
  end

  test 'should not update image_type for user' do
    patch image_type_url(@image_type), params: {image_type: {mimetype: @image_type.mimetype}}
    assert_response :unauthorized
  end

  test 'should update image_type for moderator' do
    sign_in_as(create(:moderator))
    patch image_type_url(@image_type), params: {image_type: {mimetype: @image_type.mimetype}}
    assert_response :success
  end

  test 'should not destroy image_type for user' do
    assert_difference('ImageType.count', 0) do
      delete image_type_url(@image_type)
    end

    assert_response :unauthorized
  end

  test 'should destroy image_type for moderator' do
    sign_in_as(create(:moderator))
    assert_difference('ImageType.count', -1) do
      delete image_type_url(@image_type)
    end

    assert_response :no_content
  end
end
