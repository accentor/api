class PlaysController < ApplicationController
  def create
    authorize Play
    @play = Play.new(transformed_attributes)

    if @play.save
      render json: @play, status: :created
    else
      render json: @play.errors, status: :unprocessable_entity
    end
  end

  private

  def transformed_attributes
    permitted_attributes(Play).merge(user: current_user)
  end
end
