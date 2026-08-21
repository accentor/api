require 'test_helper'

class ImageTypePolicyTest < ActiveSupport::TestCase
  setup do
    @image_type = create(:image_type)
    @user = create(:user)
    @moderator = create(:moderator)
    @admin = create(:admin)
  end

  test 'policy should not be created for signed-out user' do
    assert_raises Pundit::NotAuthorizedError do
      Pundit.policy!(nil, ImageType)
    end
  end

  test 'scope should not be created for signed-out user' do
    assert_raises Pundit::NotAuthorizedError do
      Pundit.policy_scope(nil, ImageType)
    end
  end

  test 'all users should see image types' do
    assert_scope_includes @user, @image_type
    assert_scope_includes @moderator, @image_type
    assert_scope_includes @admin, @image_type
  end

  test 'all users should be allowed to access index' do
    assert_permitted @user, ImageType, :index
    assert_permitted @moderator, ImageType, :index
    assert_permitted @admin, ImageType, :index
  end

  test 'all users should be allowed to see an image type' do
    assert_permitted @user, @image_type, :show
    assert_permitted @moderator, @image_type, :show
    assert_permitted @admin, @image_type, :show
  end

  test 'only moderator+ should be allowed to create an image type' do
    assert_not_permitted @user, ImageType, :create
    assert_permitted @moderator, ImageType, :create
    assert_permitted @admin, ImageType, :create
  end

  test 'only moderator+ should be allowed to update an image type' do
    assert_not_permitted @user, @image_type, :update
    assert_permitted @moderator, @image_type, :update
    assert_permitted @admin, @image_type, :update
  end

  test 'only moderator+ should be allowed to destroy an image type' do
    assert_not_permitted @user, @image_type, :destroy
    assert_permitted @moderator, @image_type, :destroy
    assert_permitted @admin, @image_type, :destroy
  end

  test 'moderator+ should be allowed to set all attributes of a new image type' do
    assert_no_permitted_attributes @user, ImageType, :create
    assert_attributes_permitted @moderator, ImageType, %i[mimetype extension], :create
    assert_attributes_permitted @admin, ImageType, %i[mimetype extension], :create
  end

  test 'moderator+ should be allowed to change the mimetype of an image type' do
    assert_no_permitted_attributes @user, @image_type, :update
    assert_attributes_permitted @moderator, @image_type, %i[mimetype], :update
    assert_attributes_permitted @admin, @image_type, %i[mimetype], :update
  end
end
