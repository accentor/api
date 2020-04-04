require 'test_helper'

class LabelsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @label = create(:label)
    sign_in_as(create(:user))
  end

  test 'should get index' do
    get labels_url
    assert_response :success
  end

  test 'should not create label for user' do
    label = build(:label)
    assert_difference('Label.count', 0) do
      post labels_url, params: { label: { name: label.name } }
    end

    assert_response :forbidden
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

    label2 = create :label
    create :album_label, label: label2

    assert_difference('Label.count', -1) do
      post destroy_empty_labels_url
    end

    assert_response :no_content

    assert_not_nil Label.find_by(id: label2.id)
  end

  test 'should destroy empty labels for admin' do
    sign_in_as(create(:admin))

    label2 = create :label
    create :album_label, label: label2

    assert_difference('Label.count', -1) do
      post destroy_empty_labels_url
    end

    assert_response :no_content

    assert_not_nil Label.find_by(id: label2.id)
  end

  test 'should not merge genres for user' do
    label = create(:label)

    assert_difference('Label.count', 0) do
      post merge_label_url(@label, other_label_id: label.id)
    end

    assert_response :forbidden
  end

  test 'should merge genres for moderator' do
    sign_in_as(create(:moderator))
    label = create(:label)

    assert_difference('Label.count', -1) do
      post merge_label_url(@label, other_label_id: label.id)
    end

    assert_response :success
  end
end
