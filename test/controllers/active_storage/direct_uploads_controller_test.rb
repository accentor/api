# frozen_string_literal: true

require 'test_helper'

class ActiveStorage::DirectUploadsControllerTest < ActionDispatch::IntegrationTest
  test 'should return forbidden' do
    post rails_direct_uploads_path

    assert_response :forbidden
  end
end
