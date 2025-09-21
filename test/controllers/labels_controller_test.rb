require 'test_helper'

class LabelsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @label = create(:label)
    sign_in_as(create(:user))
  end

  test 'should get index' do
    expected_etag = construct_etag(Label.order(id: :asc))

    get labels_url

    assert_response :success
    assert_equal expected_etag, headers['etag']
  end

  test 'should get index and return not modified if etag matches' do
    expected_etag = construct_etag(Label.order(id: :asc))

    get labels_url, headers: { 'If-None-Match': expected_etag }

    assert_response :not_modified
    assert_empty response.parsed_body
  end

  test 'should get index and include page in etag' do
    expected_etag = construct_etag(Label.order(id: :asc), page: 5, per_page: 501)

    get labels_url(page: 5, per_page: 501)

    assert_response :success
    assert_equal expected_etag, headers['etag']
  end

  test 'should not create label for user' do
    label = build(:label)
    assert_difference('Label.count', 0) do
      post labels_url, params: { label: { name: label.name } }
    end

    assert_response :forbidden
  end

  test 'should not create label with empty name' do
    sign_in_as(create(:moderator))

    assert_difference('Label.count', 0) do
      post labels_url, params: { label: { name: '' } }
    end

    assert_response :unprocessable_content
  end

  test 'should create label for moderator' do
    sign_in_as(create(:moderator))
    label = build(:label)
    assert_difference('Label.count', 1) do
      post labels_url, params: { label: { name: label.name } }
    end

    assert_response :created
  end

  test 'should create label for admin' do
    sign_in_as(create(:admin))
    label = build(:label)
    assert_difference('Label.count', 1) do
      post labels_url, params: { label: { name: label.name } }
    end

    assert_response :created
  end

  test 'should show label' do
    get label_url(@label)

    assert_response :success
  end

  test 'should not update label for user' do
    patch label_url(@label), params: { label: { name: @label.name } }

    assert_response :forbidden
  end

  test 'should not update label to empty name' do
    sign_in_as(create(:moderator))
    patch label_url(@label), params: { label: { name: '' } }

    assert_response :unprocessable_content
    @label.reload

    assert_not_equal '', @label.name
  end

  test 'should update label for moderator' do
    sign_in_as(create(:moderator))
    patch label_url(@label), params: { label: { name: @label.name } }

    assert_response :ok
  end

  test 'should update label for admin' do
    sign_in_as(create(:admin))
    patch label_url(@label), params: { label: { name: @label.name } }

    assert_response :ok
  end

  test 'should not destroy label for user' do
    assert_difference('Label.count', 0) do
      delete label_url(@label)
    end

    assert_response :forbidden
  end

  test 'should destroy label for moderator' do
    sign_in_as(create(:moderator))
    assert_difference('Label.count', -1) do
      delete label_url(@label)
    end

    assert_response :no_content
  end

  test 'should destroy label for admin' do
    sign_in_as(create(:admin))
    assert_difference('Label.count', -1) do
      delete label_url(@label)
    end

    assert_response :no_content
  end

  test 'should not destroy empty labels for user' do
    assert_difference('Label.count', 0) do
      post destroy_empty_labels_url
    end

    assert_response :forbidden
  end

  test 'should destroy empty labels for moderator' do
    sign_in_as(create(:moderator))

    label2 = create(:label)
    create(:album_label, label: label2)

    assert_difference('Label.count', -1) do
      post destroy_empty_labels_url
    end

    assert_response :no_content

    assert_not_nil Label.find_by(id: label2.id)
  end

  test 'should destroy empty labels for admin' do
    sign_in_as(create(:admin))

    label2 = create(:label)
    create(:album_label, label: label2)

    assert_difference('Label.count', -1) do
      post destroy_empty_labels_url
    end

    assert_response :no_content

    assert_not_nil Label.find_by(id: label2.id)
  end

  test 'should not merge labels for user' do
    label = create(:label)

    assert_difference('Label.count', 0) do
      post merge_label_url(@label, source_id: label.id)
    end

    assert_response :forbidden
  end

  test 'should merge labels for moderator' do
    sign_in_as(create(:moderator))
    label = create(:label)

    assert_difference('Label.count', -1) do
      post merge_label_url(@label, source_id: label.id)
    end

    assert_response :success
  end
end
