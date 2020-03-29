class AuthTokensController < ApplicationController
  before_action :set_auth_token, only: %i[show destroy]

  def index
    authorize AuthToken
    @auth_tokens = apply_scopes(policy_scope(AuthToken))
                   .order(id: :asc)
                   .paginate(page: params[:page], per_page: params[:per_page])
    add_pagination_headers(@auth_tokens)
    render json: @auth_tokens
  end

  def show
    render json: @auth_token
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
          .merge(user: user)
    )

    if @auth_token.save
      render json: @auth_token, serializer: AuthTokenWithSecretSerializer, status: :created
    else
      render json: @auth_token.errors, status: :unprocessable_entity
    end
  end

  def destroy
    render json: @auth_token.errors, status: :unprocessable_entity unless @auth_token.destroy
  end

  private

  def set_auth_token
    @auth_token = AuthToken.find(params[:id])
    authorize @auth_token
  end
end
