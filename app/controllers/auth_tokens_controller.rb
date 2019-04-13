class AuthTokensController < ApplicationController
  before_action :set_auth_token, only: [:show, :destroy]

  def index
    authorize AuthToken
    @auth_tokens = apply_scopes(policy_scope(AuthToken))
  end

  def show
  end

  def create
    authorize AuthToken

    user = User.find_by(name: params[:name])
    unless user.try(:authenticate, params[:password])
      render json: {unauthorized: [I18n.t('auth_tokens.create.wrong_credentials')]},
             status: :unauthorized
      return
    end

    @auth_token = AuthToken.new(
        {user_agent: request.headers[:'user-agent']}
            .merge(params[:auth_token].present? ? permitted_attributes(AuthToken) : {})
            .merge(user: user)
    )

    if @auth_token.save
      render status: :created
    else
      render json: @auth_token.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @auth_token.destroy
  end

  private

  def set_auth_token
    @auth_token = AuthToken.find(params[:id])
    authorize @auth_token
  end

end
