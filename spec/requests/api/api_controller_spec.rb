require 'rails_helper'

RSpec.describe Api::ApiController, type: :request do

  describe "Base API" do

    it "returns http success" do
      get api_path, params: nil, headers: { "HTTP_ACCEPT" => 'application/json'}
      expect(response).to have_http_status(:success)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:message]).to eq("Hello!")
    end

  end

end
