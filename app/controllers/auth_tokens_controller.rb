class AuthTokensController < ApplicationController
  before_action :set_auth_token, only: %i[show destroy]

  def index
    authorize AuthToken
    @auth_tokens = apply_scopes(policy_scope(AuthToken))
                   .order(id: :asc)
                   .paginate(page: params[:page], per_page: params[:per_page])
    add_pagination_headers(@auth_tokens)

    render json: @auth_tokens.map { transform_auth_token_for_json(it) }
  end

  def show
    render json: transform_auth_token_for_json(@auth_token)
  end

  def create
    authorize AuthToken

    user = User.find_by(name: params[:name])
    unless user.try(:authenticate, params[:password])
      render json: { unauthorized: [I18n.t('auth_tokens.create.wrong_credentials')] },
             status: :unauthorized
      return
    end

    @auth_token = AuthToken.new(
      { user_agent: request.headers[:'user-agent'] }
          .merge(params[:auth_token].present? ? permitted_attributes(AuthToken) : {})
          .merge(user:)
    )

    if @auth_token.save
      render json: transform_auth_token_for_json_with_token(@auth_token), status: :created
    else
      render json: @auth_token.errors, status: :unprocessable_content
    end
  end

  def destroy
    render json: @auth_token.errors, status: :unprocessable_content unless @auth_token.destroy
  end

  private

  def set_auth_token
    @auth_token = AuthToken.find(params[:id])
    authorize @auth_token
  end

  def transform_auth_token_for_json(auth_token)
    %i[id device_id user_id user_agent application].index_with { auth_token.send(it) }
  end

  def transform_auth_token_for_json_with_token(auth_token)
    result = transform_auth_token_for_json(auth_token)
    result[:token] = auth_token.generate_token_for(:api)

    # While clients switch to the new token, we also send the token using the secret attribute
    result[:secret] = result[:token]
    result
  end
end
