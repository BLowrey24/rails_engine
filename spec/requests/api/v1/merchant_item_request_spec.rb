require "rails_helper"

RSpec.describe "Merchant Items API" do
  it "can get items for a specific merchant" do
    merchant = create(:merchant)
    create_list(:item, 5, merchant_id: merchant.id)

    get "/api/v1/merchants/#{merchant.id}/items"
    expect(response).to be_successful
    expect(response.status).to eq(200)

    items = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(200)
    expect(items).to have_key(:data)
    expect(items[:data]).to be_an(Array)
    expect(items[:data].count).to eq(5)

    items[:data].each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)
    end
  end
end