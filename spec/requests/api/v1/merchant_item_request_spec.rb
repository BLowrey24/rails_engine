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

  it "can get a merchant by an item" do
    merchant1 = create(:merchant)
    merchant2 = create(:merchant)
    item = create(:item, merchant_id: merchant1.id)

    get "/api/v1/items/#{item.id}/merchants"
    expect(response).to be_successful
    expect(response.status).to eq(200)

    merchant_data = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(merchant_data).to have_key(:id)
    expect(merchant_data[:id].to_i).to eq(merchant1.id)
    expect(merchant_data).to have_key(:type)
    expect(merchant_data[:type]).to eq("merchant")
    expect(merchant_data).to have_key(:attributes)
    expect(merchant_data[:attributes]).to have_key(:name)
    expect(merchant_data[:attributes][:name]).to eq(merchant1.name)
  end
end