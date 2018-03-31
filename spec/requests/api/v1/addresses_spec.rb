require 'rails_helper'

RSpec.describe Api::V1::AddressesController, type: :request do

  let(:login_user)     { create(:user) }
  let(:person)         { create(:person) }

  before(:each) do
    @headers = { 'ACCEPT': 'application/json',  'CONTENT-TYPE': 'application/json' }
    sign_in login_user
    @address = create(:address, person: person)
  end

  describe "Addresses API Index " do

    it 'returns http not authorized when not signed in' do
      sign_out login_user
      get "/api/v1/people/#{person.id}/addresses", headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      get "/api/v1/people/#{person.id}/addresses", headers: @headers
      expect(response).to have_http_status(200)
    end

    it "returns the person's address" do

      get "/api/v1/people/#{person.id}/addresses", headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:address][:id]).to eq(@address.id)
      expect(u[:address][:person_id]).to eq(@address.person_id)
      expect(u[:address][:address_1]).to eq(@address.address_1)
      expect(u[:address][:address_2]).to eq(@address.address_2)
      expect(u[:address][:address_2]).to eq(@address.address_2)
      expect(u[:address][:city]).to eq(@address.city)
      expect(u[:address][:state]).to eq(@address.state)
      expect(u[:address][:zip]).to eq(@address.zip)
      expect(u[:address][:country]).to eq(@address.country)
    end

  end

  describe "Addresses API Show" do

    it "returns http not authorized when not signed in" do
      address_params      = {
                              person_id: person.id,
                              address_1: Faker::Address.street_address,
                              address_2: Faker::Address.secondary_address,
                              city: Faker::Address.city,
                              state: Faker::Address.state_abbr,
                              zip: Faker::Address.zip,
                              country: Faker::Address.country_code
                            }
      address_params_json = address_params.to_json

      sign_out login_user
      get "/api/v1/people/#{person.id}/addresses/#{@address.id}", params: address_params_json, headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      address_params      = {
                              person_id: person.id,
                              address_1: Faker::Address.street_address,
                              address_2: Faker::Address.secondary_address,
                              city: Faker::Address.city,
                              state: Faker::Address.state_abbr,
                              zip: Faker::Address.zip,
                              country: Faker::Address.country_code
                            }
      address_params_json = address_params.to_json

      get "/api/v1/people/#{person.id}/addresses/#{@address.id}", params: address_params_json, headers: @headers
      expect(response).to have_http_status(200)
    end

    it "returns the details of the specified address" do
      get "/api/v1/people/#{person.id}/addresses/#{@address.id}", headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:address][:id]).to eq(@address.id)
      expect(u[:address][:person_id]).to eq(@address.person_id)
      expect(u[:address][:address_1]).to eq(@address.address_1)
      expect(u[:address][:address_2]).to eq(@address.address_2)
      expect(u[:address][:city]).to eq(@address.city)
      expect(u[:address][:state]).to eq(@address.state)
      expect(u[:address][:zip]).to eq(@address.zip)
      expect(u[:address][:country]).to eq(@address.country)
    end

  end

  describe "Addresses API Create" do

    it "returns http not authorized when not signed in" do
      address_params      = {
                              person_id: person.id,
                              address_1: Faker::Address.street_address,
                              address_2: Faker::Address.secondary_address,
                              city: Faker::Address.city,
                              state: Faker::Address.state_abbr,
                              zip: Faker::Address.zip,
                              country: Faker::Address.country_code
                            }
      address_params_json = address_params.to_json

      sign_out login_user
      post "/api/v1/people/#{person.id}/addresses", params: address_params_json, headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      address_params      = {
                              person_id: person.id,
                              address_1: Faker::Address.street_address,
                              address_2: Faker::Address.secondary_address,
                              city: Faker::Address.city,
                              state: Faker::Address.state_abbr,
                              zip: Faker::Address.zip,
                              country: Faker::Address.country_code
                            }
      address_params_json = address_params.to_json

      post "/api/v1/people/#{person.id}/addresses/", params: address_params_json, headers: @headers
      expect(response).to have_http_status(200)
    end

    it "is successful with valid parameters" do
      address_params      = {
                              person_id: person.id,
                              address_1: Faker::Address.street_address,
                              address_2: Faker::Address.secondary_address,
                              city: Faker::Address.city,
                              state: Faker::Address.state_abbr,
                              zip: Faker::Address.zip,
                              country: Faker::Address.country_code
                            }
      address_params_json = address_params.to_json

      post "/api/v1/people/#{person.id}/addresses", params: address_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:address][:person_id]).to eq(address_params[:person_id])
      expect(u[:address][:address_1]).to eq(address_params[:address_1])
      expect(u[:address][:address_2]).to eq(address_params[:address_2])
      expect(u[:address][:city]).to eq(address_params[:city])
      expect(u[:address][:state]).to eq(address_params[:state])
      expect(u[:address][:zip]).to eq(address_params[:zip])
      expect(u[:address][:country]).to eq(address_params[:country])
    end

    it "is not successful without a first address" do
      address_params      = {
                              person_id: person.id,
                              address_1: nil,
                              address_2: Faker::Address.secondary_address,
                              city: Faker::Address.city,
                              state: Faker::Address.state_abbr,
                              zip: Faker::Address.zip,
                              country: Faker::Address.country_code
                            }
      address_params_json = address_params.to_json

      post "/api/v1/people/#{person.id}/addresses", params: address_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:address_1]).to eq(["can't be blank"])
    end

    it "is not successful without a city" do
      address_params      = {
                              person_id: person.id,
                              address_1: Faker::Address.street_address,
                              address_2: Faker::Address.secondary_address,
                              city: nil,
                              state: Faker::Address.state_abbr,
                              zip: Faker::Address.zip,
                              country: Faker::Address.country_code
                            }
      address_params_json = address_params.to_json

      post "/api/v1/people/#{person.id}/addresses", params: address_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:city]).to eq(["can't be blank"])
    end

    it "is not successful without a state if country is 'US'" do
      address_params      = {
                              person_id: person.id,
                              address_1: Faker::Address.street_address,
                              address_2: Faker::Address.secondary_address,
                              city: Faker::Address.city,
                              state: nil,
                              zip: Faker::Address.zip,
                              country: 'US'
                            }
      address_params_json = address_params.to_json

      post "/api/v1/people/#{person.id}/addresses", params: address_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:state]).to eq(["can't be blank"])
    end

    it "is not successful without a zip" do
      address_params      = {
                              person_id: person.id,
                              address_1: Faker::Address.street_address,
                              address_2: Faker::Address.secondary_address,
                              city: Faker::Address.city,
                              state: Faker::Address.state_abbr,
                              zip: nil,
                              country: Faker::Address.country_code
                            }
      address_params_json = address_params.to_json

      post "/api/v1/people/#{person.id}/addresses", params: address_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:zip]).to eq(["can't be blank"])
    end

  end

  describe "Addresses API Update" do

    it "returns http not authorized when not signed in" do
      address_params      = {
                              person_id: person.id,
                              address_1: Faker::Address.street_address,
                              address_2: Faker::Address.secondary_address,
                              city: Faker::Address.city,
                              state: Faker::Address.state_abbr,
                              zip: Faker::Address.zip,
                              country: Faker::Address.country_code
                            }
      address_params_json = address_params.to_json

      sign_out login_user
      patch "/api/v1/people/#{person.id}/addresses/#{@address.id}", params: address_params_json, headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      address_params      = {
                              person_id: person.id,
                              address_1: Faker::Address.street_address,
                              address_2: Faker::Address.secondary_address,
                              city: Faker::Address.city,
                              state: Faker::Address.state_abbr,
                              zip: Faker::Address.zip,
                              country: Faker::Address.country_code
                            }
      address_params_json = address_params.to_json

      patch "/api/v1/people/#{person.id}/addresses/#{@address.id}", params: address_params_json, headers: @headers
      expect(response).to have_http_status(200)
    end

    it "is successful with valid parameters" do
      address_params      = {
                              person_id: person.id,
                              address_1: Faker::Address.street_address,
                              address_2: Faker::Address.secondary_address,
                              city: Faker::Address.city,
                              state: Faker::Address.state_abbr,
                              zip: Faker::Address.zip,
                              country: Faker::Address.country_code
                            }
      address_params_json = address_params.to_json

      patch "/api/v1/people/#{person.id}/addresses/#{@address.id}", params: address_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:address][:person_id]).to eq(address_params[:person_id])
      expect(u[:address][:address_1]).to eq(address_params[:address_1])
      expect(u[:address][:address_2]).to eq(address_params[:address_2])
      expect(u[:address][:city]).to eq(address_params[:city])
      expect(u[:address][:state]).to eq(address_params[:state])
      # expect(u[:address][:zip]).to eq(address_params[:zip])
      expect(u[:address][:country]).to eq(address_params[:country])
    end

    it "is not successful without a first address" do
      address_params      = {
                              person_id: person.id,
                              address_1: nil,
                              address_2: Faker::Address.secondary_address,
                              city: Faker::Address.city,
                              state: Faker::Address.state_abbr,
                              zip: Faker::Address.zip,
                              country: Faker::Address.country_code
                            }
      address_params_json = address_params.to_json

      patch "/api/v1/people/#{person.id}/addresses/#{@address.id}", params: address_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:address_1]).to eq(["can't be blank"])
    end

    it "is not successful without a city" do
      address_params      = {
                              person_id: person.id,
                              address_1: Faker::Address.street_address,
                              address_2: Faker::Address.secondary_address,
                              city: nil,
                              state: Faker::Address.state_abbr,
                              zip: Faker::Address.zip,
                              country: Faker::Address.country_code
                            }
      address_params_json = address_params.to_json

      patch "/api/v1/people/#{person.id}/addresses/#{@address.id}", params: address_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:city]).to eq(["can't be blank"])
    end

    it "is not successful without a state if country is 'US'" do
      address_params      = {
                              person_id: person.id,
                              address_1: Faker::Address.street_address,
                              address_2: Faker::Address.secondary_address,
                              city: Faker::Address.city,
                              state: nil,
                              zip: Faker::Address.zip,
                              country: 'US'
                            }
      address_params_json = address_params.to_json

      patch "/api/v1/people/#{person.id}/addresses/#{@address.id}", params: address_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:state]).to eq(["can't be blank"])
    end

    it "is not successful without a zip" do
      address_params      = {
                              person_id: person.id,
                              address_1: Faker::Address.street_address,
                              address_2: Faker::Address.secondary_address,
                              city: Faker::Address.city,
                              state: Faker::Address.state_abbr,
                              zip: nil,
                              country: Faker::Address.country_code
                            }
      address_params_json = address_params.to_json

      patch "/api/v1/people/#{person.id}/addresses/#{@address.id}", params: address_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:zip]).to eq(["can't be blank"])
    end

  end

  describe "Addresses API Destroy" do

    it "returns http not authorized when not signed in" do
      sign_out login_user
      delete "/api/v1/people/#{person.id}/addresses/#{@address.id}", headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      delete "/api/v1/people/#{person.id}/addresses/#{@address.id}", headers: @headers
      expect(response).to have_http_status(200)
    end

    it "returns an empty address" do
      delete "/api/v1/people/#{person.id}/addresses/#{@address.id}", headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:address].nil?).to eq(true)
    end

  end

end
