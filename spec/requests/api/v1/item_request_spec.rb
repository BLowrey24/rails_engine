require "rails_helper"

RSpec.describe "Items API" do
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
end