class LocationsController < ApplicationController
  before_action :set_location, only: %i[show destroy]

  def index
    authorize Location
    scoped_locations = apply_scopes(policy_scope(Location)).reorder(id: :asc)
    @locations = scoped_locations.paginate(page: params[:page], per_page: params[:per_page])
    add_pagination_headers(@locations)

    render json: @locations.map { transform_location_for_json(it) } if stale?(scope: scoped_locations)
  end

  def show
    render json: transform_location_for_json(@location)
  end

  def create
    authorize Location
    @location = Location.new(permitted_attributes(Location))

    if @location.save
      render json: transform_location_for_json(@location), status: :created
    else
      render json: @location.errors, status: :unprocessable_content
    end
  end

  def destroy
    render json: @location.errors, status: :unprocessable_content unless @location.destroy
  end

  private

  def set_location
    @location = Location.find(params[:id])
    authorize @location
  end

  def transform_location_for_json(location)
    %i[id path created_at updated_at].index_with { location.send(it) }
  end
end
