class UsersController < ApplicationController
  before_action :set_user, only: %i[show update destroy]

  def index
    authorize User
    @users = apply_scopes(policy_scope(User))
             .order(id: :asc)
             .paginate(page: params[:page], per_page: params[:per_page])
    add_pagination_headers(@users)
    render json: @users
  end

  def show
    render json: @user
  end

  def create
    authorize User
    @user = User.new(permitted_attributes(User))

    if @user.save
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    if @user == current_user && params[:user][:password].present?
      unless @user.try(:authenticate, params[:user][:current_password])
        render json: { unauthorized: [I18n.t('users.current_password_is_incorrect')] },
               status: :unauthorized
        return
      end
    end

    if @user.update(permitted_attributes(@user))
      render json: @user, status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    render json: @user.errors, status: :unprocessable_entity unless @user.destroy
  end

  private

  def set_user
    @user = User.find(params[:id])
    authorize @user
  end
end
