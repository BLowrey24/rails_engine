class Api::V1::MerchantSearchController < ApplicationController
  def show
    render json: MerchantSerializer.new(Merchant.merchant_search(params[:name]))
  end
end