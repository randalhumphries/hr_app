require 'rails_helper'

RSpec.describe Api::V1::Admin::RacesController, type: :request do

  let(:random_name) { generate_random_string(16) }
  let(:login_user)  { create(:user, :admin) }
  let(:race)        { create(:race, name: random_name) }

  before(:each) do
    @headers = { 'ACCEPT': 'application/json',  'CONTENT-TYPE': 'application/json' }
    sign_in login_user
  end

  describe "Races API Index " do

    it 'returns http not authorized when not signed in' do
      sign_out login_user
      get "/api/v1/admin/races", headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      get "/api/v1/admin/races", headers: @headers
      expect(response).to have_http_status(200)
    end

    it "returns the list of races" do
      @races = []
      @races << build(:race, name: "HISPANIC OR LATINO")
      @races << build(:race, name: "AFRICAN AMERICAN")
      @races << build(:race, name: "WHITE")
      @races.sort!

      get "/api/v1/admin/races", headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      u[:races].each_with_index do |race, index|
        expect(race[:id]).to eq(@races[index].id)
        expect(race[:name]).to eq(@races[index].name)
      end
    end

  end

  describe "Races API Show" do

    it "returns http not authorized when not signed in" do
      race_params      = { name: "AMERICAN INDIAN OR PACIFIC ISLANDER" }
      race_params_json = race_params.to_json

      sign_out login_user
      get "/api/v1/admin/races/#{race.id}", params: race_params_json, headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      race_params      = { name: "AMERICAN INDIAN OR PACIFIC ISLANDER" }
      race_params_json = race_params.to_json

      get "/api/v1/admin/races/#{race.id}", params: race_params_json, headers: @headers
      expect(response).to have_http_status(200)
    end

    it "returns the details of the specified race" do
      race_params      = { name: "AMERICAN INDIAN OR PACIFIC ISLANDER" }
      race_params_json = race_params.to_json

      get "/api/v1/admin/races/#{race.id}", params: race_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:race][:id]).to eq(race.id)
      expect(u[:race][:name]).to eq(race.name)
    end

  end

  describe "Races API Create" do

    it "returns http not authorized when not signed in" do
      race_params      = { name: "AFRICAN AMERICAN" }
      race_params_json = race_params.to_json

      sign_out login_user
      post "/api/v1/admin/races", params: race_params_json, headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      race_params      = { name: "AFRICAN AMERICAN" }
      race_params_json = race_params.to_json

      post "/api/v1/admin/races/", params: race_params_json, headers: @headers
      expect(response).to have_http_status(200)
    end

    it "is successful with valid parameters" do
      race_params      = { name: "AFRICAN AMERICAN" }
      race_params_json = race_params.to_json

      post "/api/v1/admin/races", params: race_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:race][:name]).to eq(race_params[:name])
    end

    it "is not successful without a name" do
      race_params      = { name: nil }
      race_params_json = race_params.to_json

      post "/api/v1/admin/races", params: race_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:name]).to eq(["can't be blank"])
    end

    it "is not successful with a dupliate name" do
      race_params    = create(:race, name: "AFRICAN AMERICAN")
      race_params_json = race_params.to_json

      post "/api/v1/admin/races", params: race_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:name]).to eq(["has already been taken"])
    end

  end

  describe "Race API Update" do

    it "returns http not authorized when not signed in" do
      race_params      = { name: "HISPANIC OR LATINO" }
      race_params_json = race_params.to_json

      sign_out login_user
      patch "/api/v1/admin/races/#{race.id}", params: race_params_json, headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      race_params      = { name: "HISPANIC OR LATINO" }
      race_params_json = race_params.to_json

      patch "/api/v1/admin/races/#{race.id}", params: race_params_json, headers: @headers
      expect(response).to have_http_status(200)
    end

    it "is successful with valid parameters" do
      race_params      = { name: "HISPANIC OR LATINO" }
      race_params_json = race_params.to_json

      patch "/api/v1/admin/races/#{race.id}", params: race_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:race][:name]).to eq(race_params[:name])
    end

    it "is not successful without a name" do
      race_params      = { name: nil }
      race_params_json = race_params.to_json

      patch "/api/v1/admin/races/#{race.id}", params: race_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:name]).to eq(["can't be blank"])
    end

    it "is not successful with a duplicate name" do
      race_params      = create(:race, name: "HISPANIC OR LATINO")
      race_params_json = race_params.to_json

      patch "/api/v1/admin/races/#{race.id}", params: race_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:name]).to eq(["has already been taken"])
    end

  end

  describe "Race API Destroy" do

    it "returns http not authorized when not signed in" do
      sign_out login_user
      delete "/api/v1/admin/races/#{race.id}", headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      delete "/api/v1/admin/races/#{race.id}", headers: @headers
      expect(response).to have_http_status(200)
    end

    it "returns the list of races without the deleted race" do
      delete "/api/v1/admin/races/#{race.id}", headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:races].any? { |race| race }).to eq(false)
    end

  end

end
