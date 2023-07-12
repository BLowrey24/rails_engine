require "rails_helper"

RSpec.describe "Items API" do
  describe "Happy Path" do
    it "returns all items" do
      merchant_id = create(:merchant).id
      items = create_list(:item, 5, merchant_id: merchant_id)

      get "/api/v1/items"
      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)[:data]

      items.each do |item|
        expect(item).to have_key(:id)
        expect(item[:id].to_i).to be_an(Integer)

        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes]).to have_key(:unit_price)
      end
    end

    it "returns one item based on the id given" do
      merchant_id = create(:merchant).id
      item1 = create(:item, merchant_id: merchant_id)
      item2 = create(:item, merchant_id: merchant_id)

      get "/api/v1/items/#{item1.id}"
      expect(response).to be_successful

      item_data = JSON.parse(response.body, symbolize_names: true)

      expect(item_data.count).to eq(1)
      expect(item_data[:data]).to have_key(:id)
      expect(item_data[:id].to_i).to be_an(Integer)
      expect(item_data[:data][:attributes]).to have_key(:name)
      expect(item_data[:data][:attributes][:name]).to be_an(String)
      expect(item_data[:data][:attributes][:name]).to eq(item1.name)
    end
  end
end