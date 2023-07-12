require 'rails_helper'

RSpec.describe "Merchants API" do
  describe "Happy Path" do
    it "returns all merchants" do
      create_list(:merchant, 10)

      get '/api/v1/merchants'
      expect(response).to be_successful
    end
  end
end