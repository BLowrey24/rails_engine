require "rails_helper"

describe "Merchant Search API" do
  describe "Happy Path" do
    it "sends back one merchant based on the search" do
      merchant1 = create(:merchant, name: "Boston")
      merchant2 = create(:merchant, name: "Not Boston")

      get "/api/v1/merchants/find?name=#{merchant1.name}"
      expect(response).to be_successful
      expect(response.status).to eq(200)

      search_response = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(search_response).to have_key(:id)
      expect(search_response[:id].to_i).to eq(merchant1.id)
      expect(search_response).to have_key(:type)
      expect(search_response[:type]).to eq("merchant")
      expect(search_response).to have_key(:attributes)
      expect(search_response[:attributes]).to have_key(:name)
      expect(search_response[:attributes][:name]).to eq(merchant1.name)
    end
  end

  describe "Sad Path" do
    it "returns an error if the keyword does not match a name in the DB" do
      get "/api/v1/merchants/find?name=billy"
      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error).to have_key(:errors)
      expect(error[:errors]).to be_an(Array)
      expect(error[:errors][0]).to have_key(:detail)
      expect(error[:errors][0][:detail]).to eq("No merchant found with name billy.")
    end
  end
end