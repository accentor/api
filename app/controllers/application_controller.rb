class ApplicationController < ActionController::API
  include Pundit::Authorization
  include ActionController::HttpAuthentication::Token::ControllerMethods

  # This map only includes the type of validation errors that we could have inside the app
  ERROR_TYPE_MAP = { blank: :required, taken: :not_unique }.freeze

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

  # We extend `stale?` so we can manually calculate an etag from a scoped collection.
  # We don't user rails' method directly to avoid a combined query for the size and `MAX(updated_at)` of the collection
  # We already have the total size of the collection, due to pagination and can leverage indexes better if we only get `MAX(updated_at)`
  # The format we output matches rails' `cache_key_with_version`
  def stale?(scope:, **)
    timestamp = scope.unscope(:group).maximum(:updated_at)&.utc&.to_fs(scope.cache_timestamp_format)
    etag = [scope.cache_key, scope.unscope(:group).size, timestamp].compact.join('-')

    super(etag:, **)
  end

  def transform_error_for_json(object, error)
    { model: object.model_name.singular, attribute: error.attribute, type: ERROR_TYPE_MAP[error.type] }
  end

  # This method expects an instance of a class that includes `ActiveModel::Errors`
  def transform_errors_for_json(object)
    { errors: object.errors.errors.map { transform_error_for_json(object, it) } }
  end

  private

  def authenticate_user
    token = authenticate_with_http_token { AuthToken.find_by_token_for(:api, it) }
    token ||= AuthToken.find_by_token_for(:api, params[:token])

    self.current_user = token&.user
  end

  def user_not_authorized(exc)
    status = current_user.present? ? :forbidden : :unauthorized
    render json: { errors: [{ policy: exc.policy.class.to_s.underscore, type: status, action: exc.query }] }, status:
  end

  def model_not_found(exc)
    render json: { errors: [{ model: exc.model.downcase, type: :not_found }] }, status: :not_found
  end
end
