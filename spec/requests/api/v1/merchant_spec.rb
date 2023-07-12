require 'rails_helper'

RSpec.describe "Merchants API" do
  describe "Happy Path" do
    it "returns all merchants" do
      create_list(:merchant, 10)

      get '/api/v1/merchants'
      expect(response).to be_successful

      merchants_data = JSON.parse(response.body, symbolize_names: true)
      merchants = merchants_data[:data]
      expect(merchants.count).to eq(10)

      merchants.each do |merchant|
        expect(merchant).to have_key(:id)
        expect(merchant[:id].to_i).to be_an(Integer)
        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).to be_an(String)
      end
    end

    it "can get one merchant by ID" do
      merchant = create(:merchant)
      get "/api/v1/merchants/#{merchant.id}"
      expect(response).to be_successful

      merchant_response = JSON.parse(response.body, symbolize_names: true)
      expect(merchant_response[:data]).to have_key(:id)
      expect(merchant_response[:data][:id].to_i).to be_a(Integer)
      expect(merchant_response[:data][:attributes]).to have_key(:name)
      expect(merchant_response[:data][:attributes][:name]).to eq(merchant.name)
    end
  end
end