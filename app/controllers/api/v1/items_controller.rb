class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    if Item.exists?(params[:id])
      render json: ItemSerializer.new(Item.find(params[:id]))
    else
      render json: ErrorSerializer.serialize("Item not found."), status: 404
    end
  end

  def create
    item = Item.new(item_params)
    if item.save
      render json: ItemSerializer.new(item), status: 201
    else
      render json: ErrorSerializer.serialize("No fields can be blank."), status: 400
    end
  end

  def update
    if Item.exists?(params[:id])
      item = Item.find(params[:id])
      if item.update(item_params)
        render json: ItemSerializer.new(item)
      else
        render json: ErrorSerializer.serialize("Failed to update item."), status: 400
      end
    else
      render json: ErrorSerializer.serialize("Item not found."), status: 404
    end
  end

  def destroy
    if Item.exists?(params[:id])
      render json: Item.delete(params[:id])
    else
      render json: ErrorSerializer.serialize("Item not found."), status: 404
    end
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end
