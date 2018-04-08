require 'rails_helper'

RSpec.describe Api::V1::Admin::BenefitTypesController, type: :request do

  let(:random_name)  { generate_random_string(16) }
  let(:login_user)    { create(:user, :admin) }
  let(:benefit_type)  { create(:benefit_type, name: random_name) }

  before(:each) do
    @headers = { 'ACCEPT': 'application/json',  'CONTENT-TYPE': 'application/json' }
    sign_in login_user
  end

  describe "Benefit Types API Index " do

    it 'returns http not authorized when not signed in' do
      sign_out login_user
      get "/api/v1/admin/benefit_types", headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      get "/api/v1/admin/benefit_types", headers: @headers
      expect(response).to have_http_status(200)
    end

    it "returns the list of benefit types" do
      @benefit_types = []
      @benefit_types << build(:benefit_type, name: "HEALTHCARE")
      @benefit_types << build(:benefit_type, name: "VISION")
      @benefit_types.sort!

      get "/api/v1/admin/benefit_types", headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      u[:benefit_types].each_with_index do |benefit_type, index|
        expect(benefit_type[:id]).to eq(@benefit_types[index].id)
        expect(benefit_type[:name]).to eq(@benefit_types[index].name)
        expect(benefit_type[:eligibility_interval]).to eq(@benefit_types[index].eligibility_interval)
        expect(benefit_type[:eligibility_interval_unit]).to eq(@benefit_types[index].eligibility_interval_unit)
      end
    end

  end

  describe "Benefit Types API Show" do

    it "returns http not authorized when not signed in" do
      benefit_type_params      = { name: "HEALTHCARE", eligibility_interval: 6, eligibility_interval_unit: "months" }
      benefit_type_params_json = benefit_type_params.to_json

      sign_out login_user
      get "/api/v1/admin/benefit_types/#{benefit_type.id}", params: benefit_type_params_json, headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      benefit_type_params      = { name: "HEALTHCARE", eligibility_interval: 6, eligibility_interval_unit: "months" }
      benefit_type_params_json = benefit_type_params.to_json

      get "/api/v1/admin/benefit_types/#{benefit_type.id}", params: benefit_type_params_json, headers: @headers
      expect(response).to have_http_status(200)
    end

    it "returns the details of the specified benefit type" do
      benefit_type_params      = { name: "HEALTHCARE", eligibility_interval: 6, eligibility_interval_unit: "months" }
      benefit_type_params_json = benefit_type_params.to_json

      get "/api/v1/admin/benefit_types/#{benefit_type.id}", params: benefit_type_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:benefit_type][:id]).to eq(benefit_type.id)
      expect(u[:benefit_type][:name]).to eq(benefit_type.name)
      expect(u[:benefit_type][:eligibility_interval]).to eq(benefit_type.eligibility_interval)
      expect(u[:benefit_type][:eligibility_interval_unit]).to eq(benefit_type.eligibility_interval_unit)
    end

  end

  describe "Benefit Types API Create" do

    it "returns http not authorized when not signed in" do
      benefit_type_params      = { name: "HEALTHCARE", eligibility_interval: 6, eligibility_interval_unit: "months" }
      benefit_type_params_json = benefit_type_params.to_json

      sign_out login_user
      post "/api/v1/admin/benefit_types", params: benefit_type_params_json, headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      benefit_type_params      = { name: "HEALTHCARE", eligibility_interval: 6, eligibility_interval_unit: "months" }
      benefit_type_params_json = benefit_type_params.to_json

      post "/api/v1/admin/benefit_types/", params: benefit_type_params_json, headers: @headers
      expect(response).to have_http_status(200)
    end

    it "is successful with valid parameters" do
      benefit_type_params      = { name: "HEALTHCARE", eligibility_interval: 6, eligibility_interval_unit: "months" }
      benefit_type_params_json = benefit_type_params.to_json

      post "/api/v1/admin/benefit_types", params: benefit_type_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:benefit_type][:name]).to eq(benefit_type_params[:name])
    end

    it "is not successful without a name" do
      benefit_type_params      = { name: nil, eligibility_interval: 6, eligibility_interval_unit: "months" }
      benefit_type_params_json = benefit_type_params.to_json

      post "/api/v1/admin/benefit_types", params: benefit_type_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:name]).to eq(["can't be blank"])
    end

    it "is not successful with a dupliate name" do
      benefit_type_params      = create(:benefit_type, name: "HEALTHCARE")
      benefit_type_params_json = benefit_type_params.to_json

      post "/api/v1/admin/benefit_types", params: benefit_type_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:name]).to eq(["has already been taken"])
    end

    it "is not successful without an eligibility interval" do
      benefit_type_params      = { name: "HEALTHCARE", eligibility_interval: nil, eligibility_interval_unit: "months" }
      benefit_type_params_json = benefit_type_params.to_json

      post "/api/v1/admin/benefit_types", params: benefit_type_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:eligibility_interval]).to eq(["can't be blank"])
    end

    it "is not successful without an eligibility interval unit" do
      benefit_type_params      = { name: "HEALTHCARE", eligibility_interval: 6, eligibility_interval_unit: nil }
      benefit_type_params_json = benefit_type_params.to_json

      post "/api/v1/admin/benefit_types", params: benefit_type_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:eligibility_interval_unit]).to eq(["can't be blank"])
    end

  end

  describe "Benefit Types API Update" do

    it "returns http not authorized when not signed in" do
      benefit_type_params      = { name: "HEALTHCARE", eligibility_interval: 6, eligibility_interval_unit: "months" }
      benefit_type_params_json = benefit_type_params.to_json

      sign_out login_user
      patch "/api/v1/admin/benefit_types/#{benefit_type.id}", params: benefit_type_params_json, headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      benefit_type_params      = { name: "HEALTHCARE", eligibility_interval: 6, eligibility_interval_unit: "months" }
      benefit_type_params_json = benefit_type_params.to_json

      patch "/api/v1/admin/benefit_types/#{benefit_type.id}", params: benefit_type_params_json, headers: @headers
      expect(response).to have_http_status(200)
    end

    it "is successful with valid parameters" do
      benefit_type_params      = { name: "HEALTHCARE", eligibility_interval: 6, eligibility_interval_unit: "months" }
      benefit_type_params_json = benefit_type_params.to_json

      patch "/api/v1/admin/benefit_types/#{benefit_type.id}", params: benefit_type_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:benefit_type][:name]).to eq(benefit_type_params[:name])
    end

    it "is not successful without a name" do
      benefit_type_params      = { name: nil, eligibility_interval: 6, eligibility_interval_unit: "months" }
      benefit_type_params_json = benefit_type_params.to_json

      patch "/api/v1/admin/benefit_types/#{benefit_type.id}", params: benefit_type_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:name]).to eq(["can't be blank"])
    end

    it "is not successful with a duplicate name" do
      benefit_type_params      = create(:benefit_type, name: "HEALTHCARE")
      benefit_type_params_json = benefit_type_params.to_json

      patch "/api/v1/admin/benefit_types/#{benefit_type.id}", params: benefit_type_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:name]).to eq(["has already been taken"])
    end

    it "is not successful without an eligibility interval" do
      benefit_type_params      = { name: "HEALTHCARE", eligibility_interval: nil, eligibility_interval_unit: "months" }
      benefit_type_params_json = benefit_type_params.to_json

      patch "/api/v1/admin/benefit_types/#{benefit_type.id}", params: benefit_type_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:eligibility_interval]).to eq(["can't be blank"])
    end

    it "is not successful without an eligibility interval unit" do
      benefit_type_params      = { name: "HEALTHCARE", eligibility_interval: 6, eligibility_interval_unit: nil }
      benefit_type_params_json = benefit_type_params.to_json

      patch "/api/v1/admin/benefit_types/#{benefit_type.id}", params: benefit_type_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:eligibility_interval_unit]).to eq(["can't be blank"])
    end

  end

  describe "Benefit Types API Destroy" do

    it "returns http not authorized when not signed in" do
      sign_out login_user
      delete "/api/v1/admin/benefit_types/#{benefit_type.id}", headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      delete "/api/v1/admin/benefit_types/#{benefit_type.id}", headers: @headers
      expect(response).to have_http_status(200)
    end

    it "returns the list of benefit types without the deleted benefit type" do
      delete "/api/v1/admin/benefit_types/#{benefit_type.id}", headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:benefit_types].any? { |value| benefit_type }).to eq(false)
    end

  end

end
