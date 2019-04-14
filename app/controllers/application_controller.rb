class ApplicationController < ActionController::API
  include Pundit

  attr_accessor :current_user

  before_action :authenticate_from_token
  after_action :verify_authorized
  after_action :verify_policy_scoped, only: :index

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :model_not_found

  private

  def authenticate_from_token
    token = AuthToken.find_authenticated(
        {
            secret: (request.headers[:'x-secret'] || params[:secret]),
            device_id: (request.headers[:'x-device-id'] || params[:device_id])
        }
    )
    self.current_user = token&.user
  end

  def user_not_authorized(exc)
    policy_name = exc.policy.class.to_s.underscore

    render json: {unauthorized: [I18n.t("#{policy_name}.#{exc.query}",
                                       scope: 'pundit',
                                       default: :default)]},
           status: :unauthorized
  end

  def model_not_found(exc)
    render json: {not_found: [exc.message]}, status: :not_found
  end
end
