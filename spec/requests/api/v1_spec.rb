require 'rails_helper'

RSpec.describe Api::V1Controller, type: :request do

  let(:user)  { create(:user) }

  before(:each) do
    @headers = { 'ACCEPT': 'application/json',  'CONTENT-TYPE': 'application/json' }
    sign_in user
  end

  describe "v1 API" do

    it "returns http success" do
      get "/api/v1", params: nil, headers: @headers
      expect(response).to have_http_status(200)
    end

    it "returns http not found" do
      get "/api/v1/not_found", params: nil, headers: @headers
      expect(response).to have_http_status(404)
    end

    it "returns http not authorized", skip_before: true do
      sign_out user
      get "/api/v1/not_authorized", params: nil, headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http application error" do
      get "/api/v1/application_error", params: nil, headers: @headers
      expect(response).to have_http_status(500)
    end

  end

end
