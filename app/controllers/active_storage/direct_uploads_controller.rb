# frozen_string_literal: true

# We override the builtin direct uploads controller, to disable this feature entirely
class ActiveStorage::DirectUploadsController < ActiveStorage::BaseController
  def create
    head :forbidden
  end
end
