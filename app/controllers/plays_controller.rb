class PlaysController < ApplicationController
  def create
    authorize Play
    @play = Play.new(permitted_attributes(Play))

    if @play.save
      render json: @play, status: :created
    else
      render json: @play.errors, status: :unprocessable_entity
    end
  end
end
