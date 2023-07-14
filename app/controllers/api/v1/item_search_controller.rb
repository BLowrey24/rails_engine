class Api::V1::ItemSearchController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.items_search(params[:name]))
  end
end