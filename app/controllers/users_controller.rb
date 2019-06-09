class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  def index
    authorize User
    @users = apply_scopes(policy_scope(User))
                 .order(id: :asc)
                 .paginate(page: params[:page])
  end

  def show
  end

  def create
    authorize User
    @user = User.new(permitted_attributes(User))

    if @user.save
      render :show, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(permitted_attributes(@user))
      render :show, status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    unless @user.destroy
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
    authorize @user
  end

end
