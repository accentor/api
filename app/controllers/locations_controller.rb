class LocationsController < ApplicationController
  before_action :set_location, only: [:show, :destroy]

  def index
    authorize Location
    @locations = apply_scopes(policy_scope(Location))
  end

  def show
  end

  def create
    authorize Location
    @location = Location.new(permitted_attributes(Location))

    if @location.save
      render :show, status: :created
    else
      render json: @location.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @location.destroy
  end

  private

  def set_location
    @location = Location.find(params[:id])
    authorize @location
  end
end
