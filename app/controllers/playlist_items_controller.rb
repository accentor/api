class PlaylistItemsController < ApplicationController
  def create
    @item = PlaylistItem.new(permitted_attributes(PlaylistItem))
    authorize @item

    render json: @item.errors, status: :unprocessable_entity unless @item.save
  end
end
