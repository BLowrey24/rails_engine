require "rails_helper"

RSpec.describe "Items API" do
  describe "Happy Path" do
    it "returns all items" do
      merchant_id = create(:merchant).id
      items = create_list(:item, 5, merchant_id: merchant_id)

      get "/api/v1/items"
      expect(response).to be_successful
      expect(response.status).to eq(200)

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
      expect(response.status).to eq(200)

      item_data = JSON.parse(response.body, symbolize_names: true)

      expect(item_data.count).to eq(1)
      expect(item_data[:data]).to have_key(:id)
      expect(item_data[:id].to_i).to be_an(Integer)
      expect(item_data[:data][:attributes]).to have_key(:name)
      expect(item_data[:data][:attributes][:name]).to be_an(String)
      expect(item_data[:data][:attributes][:name]).to eq(item1.name)
    end

    it "can create an item" do
      merchant_id = create(:merchant).id
      item_params = ({
        name: "Keyboard",
        description: "Best mechanical keyboard ever.",
        unit_price: 100.00,
        merchant_id: merchant_id
        })
      header = {"CONTENT_TYPE" => "application/json"}

      post "/api/v1/items", headers: header, params: JSON.generate(item: item_params)
      expect(response).to be_successful
      expect(response.status).to eq(201)

      item_data = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(item_data).to have_key(:id)
      expect(item_data[:id].to_i).to be_an(Integer)
      expect(item_data).to have_key(:type)
      expect(item_data[:type]).to eq("item")

      expect(item_data).to have_key(:attributes)
      expect(item_data[:attributes]).to have_key(:name)
      expect(item_data[:attributes][:name]).to eq("Keyboard")
      expect(item_data[:attributes]).to have_key(:description)
      expect(item_data[:attributes][:description]).to eq("Best mechanical keyboard ever.")
      expect(item_data[:attributes]).to have_key(:unit_price)
      expect(item_data[:attributes][:unit_price]).to eq(100.00)
      expect(item_data[:attributes]).to have_key(:merchant_id)
      expect(item_data[:attributes][:merchant_id]).to eq(merchant_id)
    end

    it "can edit an already existing item" do
      merchant_id = create(:merchant).id
      item = create(:item, merchant_id: merchant_id)
      item_params = ({
        name: "Keyboard",
        description: "Best mechanical keyboard ever.",
        unit_price: 100.00,
        merchant_id: merchant_id
        })
        header = {"CONTENT_TYPE" => "application/json"}

        patch "/api/v1/items/#{item.id}", headers: header, params: JSON.generate(item: item_params)
        expect(response).to be_successful
        expect(response.status).to eq(200)

        updated_item = Item.last
        expect(updated_item.name).to eq("Keyboard")
        expect(updated_item.description).to eq("Best mechanical keyboard ever.")
        expect(updated_item.unit_price).to eq(100.00)
        expect(updated_item.merchant_id).to eq(merchant_id)
    end

    it "can delete a item" do
      merchant = create(:merchant)
      item1 = create(:item, merchant_id: merchant.id)
      item2 = create(:item, merchant_id: merchant.id)

      expect(merchant.items.count).to eq(2)

      delete "/api/v1/items/#{item1.id}"
      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(merchant.items.count).to eq(1)
    end
  end

  describe "Sad Path" do
    it "returns an error if the item does not exist" do
      get "/api/v1/items/101"
      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error).to have_key(:errors)
      expect(error[:errors]).to be_an(Array)
      expect(error[:errors][0]).to have_key(:detail)
      expect(error[:errors][0][:detail]).to eq("Item not found.")
    end

    it "cannot create an item with empty fields" do
      merchant_id = create(:merchant).id
      item_params = ({
        name: "",
        description: "Best mechanical keyboard ever.",
        unit_price: 100.00,
        merchant_id: merchant_id
        })
      header = {"CONTENT_TYPE" => "application/json"}

      post "/api/v1/items", headers: header, params: JSON.generate(item: item_params)
      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error).to have_key(:errors)
      expect(error[:errors]).to be_an(Array)
      expect(error[:errors][0]).to have_key(:detail)
      expect(error[:errors][0][:detail]).to eq("No fields can be blank.")
    end

    it "cannot update an item that does not exist" do
      merchant_id = create(:merchant).id
      item_params = ({
        name: "Keyboard",
        description: "Best mechanical keyboard ever.",
        unit_price: 100.00,
        merchant_id: merchant_id
        })
      header = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/items/101", headers: header, params: JSON.generate(item: item_params)
      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error).to have_key(:errors)
      expect(error[:errors]).to be_an(Array)
      expect(error[:errors][0]).to have_key(:detail)
      expect(error[:errors][0][:detail]).to eq("Item not found.")
    end

    it "returns a 400 error when the update fails" do
      merchant_id = create(:merchant).id
      item = create(:item, merchant_id: merchant_id)
      invalid_params = {
        name: nil,
        description: "New description",
        unit_price: 50.00
      }
      header = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/items/#{item.id}", headers: header, params: JSON.generate(item: invalid_params)
      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error).to have_key(:errors)
      expect(error[:errors]).to be_an(Array)
      expect(error[:errors][0]).to have_key(:detail)
      expect(error[:errors][0][:detail]).to eq("Failed to update item.")
    end

    it "cannot delete an item that does not exist" do
      delete "/api/v1/items/101"
      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error).to have_key(:errors)
      expect(error[:errors]).to be_an(Array)
      expect(error[:errors][0]).to have_key(:detail)
      expect(error[:errors][0][:detail]).to eq("Item not found.")
    end
  end
end
