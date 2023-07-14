require 'rails_helper'

RSpec.describe "Merchants API" do
  describe "Happy Path" do
    it "returns all merchants" do
      create_list(:merchant, 10)

      get '/api/v1/merchants'
      expect(response).to be_successful
      expect(response.status).to eq(200)

      merchants_data = JSON.parse(response.body, symbolize_names: true)
      merchants = merchants_data[:data]
      expect(merchants.count).to eq(10)

      merchants.each do |merchant|
        expect(merchant).to have_key(:id)
        expect(merchant[:id].to_i).to be_an(Integer)
        expect(merchant).to have_key(:type)
        expect(merchant[:type]).to eq("merchant")
        expect(merchant).to have_key(:attributes)
        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).to be_an(String)
      end
    end

    it "can get one merchant by ID" do
      merchant = create(:merchant)
      get "/api/v1/merchants/#{merchant.id}"
      expect(response).to be_successful
      expect(response.status).to eq(200)

      merchant_response = JSON.parse(response.body, symbolize_names: true)
      expect(merchant_response[:data]).to have_key(:id)
      expect(merchant_response[:data][:id].to_i).to be_a(Integer)
      expect(merchant_response[:data]).to have_key(:type)
      expect(merchant_response[:data][:type]).to eq("merchant")
      expect(merchant_response[:data][:attributes]).to have_key(:name)
      expect(merchant_response[:data][:attributes][:name]).to eq(merchant.name)
    end
  end

  describe "Sad Path" do
    it "cannot get merchant by ID if it does not match one in the DB" do
      get "/api/v1/merchants/101"
      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error).to have_key(:errors)
      expect(error[:errors]).to be_an(Array)
      expect(error[:errors][0]).to have_key(:detail)
      expect(error[:errors][0][:detail]).to eq("Merchant not found.")
    end
  end
end