require 'rails_helper'

RSpec.describe Api::V1::Admin::EthnicitiesController, type: :request do

  let(:login_user) { create(:user, :admin) }
  let(:ethnicity)       { create(:ethnicity) }

  before(:each) do
    @headers = { 'ACCEPT': 'application/json',  'CONTENT-TYPE': 'application/json' }
    sign_in login_user
  end

  describe "Ethnicities API Index " do

    it 'returns http not authorized when not signed in' do
      sign_out login_user
      get "/api/v1/admin/ethnicities", headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      get "/api/v1/admin/ethnicities", headers: @headers
      expect(response).to have_http_status(200)
    end

    it "returns the list of ethnicities" do
      @ethnicities = []
      @ethnicities << build(:ethnicity, name: "NOT HISPANIC OR LATINO")
      @ethnicities << build(:ethnicity, name: "HISPANIC OR LATINO")
      @ethnicities.sort!

      get "/api/v1/admin/ethnicities", headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      u[:ethnicities].each_with_index do |race, index|
        expect(race[:id]).to eq(@ethnicities[index].id)
        expect(race[:name]).to eq(@ethnicities[index].name)
      end
    end

  end

  describe "Ethnicities API Show" do

    it "returns http not authorized when not signed in" do
      ethnicity_params      = { name: "NOT HISPANIC OR LATINO" }
      ethnicity_params_json = ethnicity_params.to_json

      sign_out login_user
      get "/api/v1/admin/ethnicities/#{ethnicity.id}", params: ethnicity_params_json, headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      ethnicity_params      = { name: "AMERICAN INDIAN OR PACIFIC ISLANDER" }
      ethnicity_params_json = ethnicity_params.to_json

      get "/api/v1/admin/ethnicities/#{ethnicity.id}", params: ethnicity_params_json, headers: @headers
      expect(response).to have_http_status(200)
    end

    it "returns the details of the specified ethnicity" do
      ethnicity_params      = { name: "AMERICAN INDIAN OR PACIFIC ISLANDER" }
      ethnicity_params_json = ethnicity_params.to_json

      get "/api/v1/admin/ethnicities/#{ethnicity.id}", params: ethnicity_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:ethnicity][:id]).to eq(ethnicity.id)
      expect(u[:ethnicity][:name]).to eq(ethnicity.name)
    end

  end

  describe "Ethnicities API Create" do

    it "returns http not authorized when not signed in" do
      ethnicity_params      = { name: "AFRICAN AMERICAN" }
      ethnicity_params_json = ethnicity_params.to_json

      sign_out login_user
      post "/api/v1/admin/ethnicities", params: ethnicity_params_json, headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      ethnicity_params      = { name: "AFRICAN AMERICAN" }
      ethnicity_params_json = ethnicity_params.to_json

      post "/api/v1/admin/ethnicities/", params: ethnicity_params_json, headers: @headers
      expect(response).to have_http_status(200)
    end

    it "is successful with valid parameters" do
      ethnicity_params      = { name: "AFRICAN AMERICAN" }
      ethnicity_params_json = ethnicity_params.to_json

      post "/api/v1/admin/ethnicities", params: ethnicity_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:ethnicity][:name]).to eq(ethnicity_params[:name])
    end

    it "is not successful without a name" do
      ethnicity_params      = { name: nil }
      ethnicity_params_json = ethnicity_params.to_json

      post "/api/v1/admin/ethnicities", params: ethnicity_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:name]).to eq(["can't be blank"])
    end

    it "is not successful with a dupliate name" do
      ethnicity_params    = create(:ethnicity, name: "AFRICAN AMERICAN")
      ethnicity_params_json = ethnicity_params.to_json

      post "/api/v1/admin/ethnicities", params: ethnicity_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:name]).to eq(["has already been taken"])
    end

  end

  describe "Ethnicities API Update" do

    it "returns http not authorized when not signed in" do
      ethnicity_params      = { name: "HISPANIC OR LATINO" }
      ethnicity_params_json = ethnicity_params.to_json

      sign_out login_user
      patch "/api/v1/admin/ethnicities/#{ethnicity.id}", params: ethnicity_params_json, headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      ethnicity_params      = { name: "HISPANIC OR LATINO" }
      ethnicity_params_json = ethnicity_params.to_json

      patch "/api/v1/admin/ethnicities/#{ethnicity.id}", params: ethnicity_params_json, headers: @headers
      expect(response).to have_http_status(200)
    end

    it "is successful with valid parameters" do
      ethnicity_params      = { name: "HISPANIC OR LATINO" }
      ethnicity_params_json = ethnicity_params.to_json

      patch "/api/v1/admin/ethnicities/#{ethnicity.id}", params: ethnicity_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:ethnicity][:name]).to eq(ethnicity_params[:name])
    end

    it "is not successful without a name" do
      ethnicity_params      = { name: nil }
      ethnicity_params_json = ethnicity_params.to_json

      patch "/api/v1/admin/ethnicities/#{ethnicity.id}", params: ethnicity_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:name]).to eq(["can't be blank"])
    end

    it "is not successful with a duplicate name" do
      ethnicity_params      = create(:ethnicity, name: "HISPANIC OR LATINO")
      ethnicity_params_json = ethnicity_params.to_json

      patch "/api/v1/admin/ethnicities/#{ethnicity.id}", params: ethnicity_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:name]).to eq(["has already been taken"])
    end

  end

  describe "Ethnicities API Destroy" do

    it "returns http not authorized when not signed in" do
      sign_out login_user
      delete "/api/v1/admin/ethnicities/#{ethnicity.id}", headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      delete "/api/v1/admin/ethnicities/#{ethnicity.id}", headers: @headers
      expect(response).to have_http_status(200)
    end

    it "returns the list of ethnicities without the deleted ethnicity" do
      delete "/api/v1/admin/ethnicities/#{ethnicity.id}", headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:ethnicities].any? { |value| ethnicity }).to eq(false)
    end

  end

end
