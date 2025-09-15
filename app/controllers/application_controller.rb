class ApplicationController < ActionController::API
  include Pundit::Authorization
  include ActionController::HttpAuthentication::Token::ControllerMethods

  etag { params[:page] }
  etag { params[:per_page] }

  attr_accessor :current_user

  before_action :authenticate_user
  after_action :verify_authorized
  # rubocop:disable Rails/LexicallyScopedActionFilter
  # Most subclasses will have this action, if they don't we also don't need to
  # check that we used policy_scope
  after_action :verify_policy_scoped, only: :index
  # rubocop:enable Rails/LexicallyScopedActionFilter

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :model_not_found

  has_scope :sorted, default: nil, allow_blank: true, except: :stats

  protected

  def add_pagination_headers(collection)
    response.headers['x-total-entries'] = collection.total_entries
    response.headers['x-total-pages'] = collection.total_pages
    response.headers['x-current-page'] = collection.current_page
    response.headers['x-per-page'] = collection.per_page
    response.headers['x-offset'] = collection.offset
    response.headers['Access-Control-Expose-Headers'] = 'x-total-entries, x-total-pages, x-current-page, x-per-page, x-offset'
  end

  private

  def authenticate_user
    token = authenticate_with_http_token { AuthToken.find_by_token_for(:api, it) }
    token ||= AuthToken.find_by_token_for(:api, params[:token])

    self.current_user = token&.user
  end

  def user_not_authorized(exc)
    policy_name = exc.policy.class.to_s.underscore

    status = current_user.present? ? :forbidden : :unauthorized
    render json: { status => [I18n.t("#{policy_name}.#{exc.query}",
                                     scope: 'pundit',
                                     default: :default)] },
           status:
  end

  def model_not_found(exc)
    render json: { not_found: ["#{exc.model.pluralize.downcase}.not-found"] }, status: :not_found
  end
end
