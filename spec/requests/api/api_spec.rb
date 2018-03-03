require 'rails_helper'

RSpec.describe Api::ApiController, type: :request do

  before(:each) do
    @headers = { 'ACCEPT': 'application/json',  'CONTENT-TYPE': 'application/json' }
  end

  describe "Base API" do

    it "returns http success" do
      get "/api", params: nil, headers: @headers
      expect(response).to have_http_status(:success)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:message]).to eq("Hello!")
    end

  end

end
