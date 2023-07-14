require 'rails_helper'

RSpec.describe "Items Search API" do
  describe 'Happy Path' do
    it 'returns all Items based on search criteria' do
      merchant_id = create(:merchant).id

      item1 = create(:item, name: "Toilet Paper", merchant_id: merchant_id)
      item2 = create(:item, name: "Wrapping Paper", merchant_id: merchant_id)
      item3 = create(:item, name: "Napkins", merchant_id: merchant_id)

      get '/api/v1/items/find_all?name=paper'
      expect(response).to be_successful
      expect(response.status).to eq(200)

      search_response = JSON.parse(response.body, symbolize_names: true)

      search_response[:data].each do |item|
        expect(item).to have_key(:id)
        expect(item[:id].to_i).to be_an(Integer)

        expect(item).to have_key(:type)
        expect(item[:type]).to eq("item")

        expect(item).to have_key(:attributes)

        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_an(String)

        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_an(String)

        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price].to_f).to be_an(Float)

        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes][:merchant_id]).to be_an(Integer)
      end

      expect(search_response[:data][0][:attributes][:name]).to eq(item1.name)
      expect(search_response[:data][1][:attributes][:name]).to eq(item2.name)
      expect(search_response[:data][0][:attributes]).to_not include(item3.name)
    end
  end

  describe "Sad Path" do
    it "returns an error if the keyword does not math anything in the DB" do
      get '/api/v1/items/find_all?name=nothing'
      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error).to have_key(:errors)
      expect(error[:errors]).to be_an(Array)
      expect(error[:errors][0]).to have_key(:detail)
      expect(error[:errors][0][:detail]).to eq("No items found with name nothing.")
    end
  end
end