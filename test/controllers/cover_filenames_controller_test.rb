require 'test_helper'

class CoverFilenamesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cover_filename = create(:cover_filename)
    sign_in_as create(:user)
  end

  test 'should not get index for user' do
    get cover_filenames_url
    assert_response :forbidden
  end

  test 'should get index for moderator' do
    sign_in_as create(:moderator)
    get cover_filenames_url
    assert_response :success
  end

  test 'should get index for admin' do
    sign_in_as create(:admin)
    get cover_filenames_url
    assert_response :success
  end

  test 'should not create cover_filename for user' do
    cover_filename = build :cover_filename
    assert_difference('CoverFilename.count', 0) do
      post cover_filenames_url, params: { cover_filename: { filename: cover_filename.filename } }
    end

    assert_response :forbidden
  end

  test 'should create cover_filename for moderator' do
    sign_in_as create(:moderator)
    cover_filename = build :cover_filename
    assert_difference('CoverFilename.count', 1) do
      post cover_filenames_url, params: { cover_filename: { filename: cover_filename.filename } }
    end

    assert_response :created
  end

  test 'should create cover_filename for admin' do
    sign_in_as create(:admin)
    cover_filename = build :cover_filename
    assert_difference('CoverFilename.count', 1) do
      post cover_filenames_url, params: { cover_filename: { filename: cover_filename.filename } }
    end

    assert_response :created
  end

  test 'should not show cover_filename for user' do
    get cover_filename_url(@cover_filename)
    assert_response :forbidden
  end

  test 'should show cover_filename for moderator' do
    sign_in_as create(:moderator)
    get cover_filename_url(@cover_filename)
    assert_response :success
  end

  test 'should show cover_filename for admin' do
    sign_in_as create(:admin)
    get cover_filename_url(@cover_filename)
    assert_response :success
  end

  test 'should not destroy cover_filename for user' do
    assert_difference('CoverFilename.count', 0) do
      delete cover_filename_url(@cover_filename)
    end

    assert_response :forbidden
  end

  test 'should destroy cover_filename for moderator' do
    sign_in_as create(:moderator)
    assert_difference('CoverFilename.count', -1) do
      delete cover_filename_url(@cover_filename)
    end

    assert_response :no_content
  end

  test 'should destroy cover_filename for admin' do
    sign_in_as create(:admin)
    assert_difference('CoverFilename.count', -1) do
      delete cover_filename_url(@cover_filename)
    end

    assert_response :no_content
  end
end
