class Api::V1::ItemSearchController < ApplicationController
  def index
    items = Item.items_search(params[:name])
    if items.empty?
      render json: ErrorSerializer.serialize("No items found with name #{params[:name]}."), status: 404
    else
      render json: ItemSerializer.new(items)
    end
  end
end