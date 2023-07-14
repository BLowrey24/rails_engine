class Api::V1::MerchantSearchController < ApplicationController
  def show
    merchant = Merchant.merchant_search(params[:name])
    if merchant.nil?
      render json: ErrorSerializer.serialize("No merchant found with name #{params[:name]}."), status: 404
    else
      render json: MerchantSerializer.new(merchant)
    end
  end
end