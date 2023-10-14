require 'test_helper'

class LocationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @location = create(:location)
    sign_in_as create(:user)
  end

  test 'should not get index for user' do
    get locations_url

    assert_response :forbidden
  end

  test 'should get index for moderator' do
    sign_in_as create(:moderator)
    get locations_url

    assert_response :success
  end

  test 'should get index for admin' do
    sign_in_as create(:admin)
    get locations_url

    assert_response :success
  end

  test 'should not create location for user' do
    location = build(:location)
    assert_difference('Location.count', 0) do
      post locations_url, params: { location: { path: location.path } }
    end

    assert_response :forbidden
  end

  test 'should not create location with empty path' do
    sign_in_as create(:moderator)
    assert_difference('Location.count', 0) do
      post locations_url, params: { location: { path: '' } }
    end

    assert_response :unprocessable_entity
  end

  test 'should create location for moderator' do
    sign_in_as create(:moderator)
    location = build(:location)
    assert_difference('Location.count', 1) do
      post locations_url, params: { location: { path: location.path } }
    end

    assert_response :created
  end

  test 'should create location for admin' do
    sign_in_as create(:admin)
    location = build(:location)
    assert_difference('Location.count', 1) do
      post locations_url, params: { location: { path: location.path } }
    end

    assert_response :created
  end

  test 'should not show location for user' do
    get location_url(@location)

    assert_response :forbidden
  end

  test 'should show location for moderator' do
    sign_in_as create(:moderator)
    get location_url(@location)

    assert_response :success
  end

  test 'should show location for admin' do
    sign_in_as create(:admin)
    get location_url(@location)

    assert_response :success
  end

  test 'should not destroy location for user' do
    assert_difference('Location.count', 0) do
      delete location_url(@location)
    end

    assert_response :forbidden
  end

  test 'should destroy location for moderator' do
    sign_in_as create(:moderator)
    assert_difference('Location.count', -1) do
      delete location_url(@location)
    end

    assert_response :no_content
  end

  test 'should destroy location for admin' do
    sign_in_as create(:admin)
    assert_difference('Location.count', -1) do
      delete location_url(@location)
    end

    assert_response :no_content
  end
end
