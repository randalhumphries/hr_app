require 'rails_helper'

RSpec.describe Api::V1::Admin::CertificationTypesController, type: :request do

  let(:login_user)          { create(:user, :admin) }
  let(:certification_type)  { create(:certification_type) }

  before(:each) do
    @headers = { 'ACCEPT': 'application/json',  'CONTENT-TYPE': 'application/json' }
    sign_in login_user
  end

  describe "Certification Types API Index" do
    
    it 'returns http not authorized when not signed in' do
      sign_out login_user
      get "/api/v1/admin/certification_types", headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      get "/api/v1/admin/certification_types", headers: @headers
      expect(response).to have_http_status(200)
    end

    it "returns the list of certification types" do
      @certification_types = []
      @certification_types << build(:certification_type, name: "BBPD")
      @certification_types << build(:certification_type, name: "MEDICAL")
      @certification_types.sort!

      get "/api/v1/admin/certification_types", headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      u[:certification_types].each_with_index do |certification_type, index|
        expect(certification_type[:id]).to eq(@certification_types[index].id)
        expect(certification_type[:name]).to eq(@certification_types[index].name)
        expect(certification_type[:effective_interval]).to eq(@certification_types[index].effective_interval)
        expect(certification_type[:effective_interval_unit]).to eq(@certification_types[index].effective_interval_unit)
      end
    end

  end

  describe "Certification Types API Show" do
    
    it "returns http not authorized when not signed in" do
      sign_out login_user
      get "/api/v1/admin/certification_types/#{certification_type.id}", headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      get "/api/v1/admin/certification_types/#{certification_type.id}", headers: @headers
      expect(response).to have_http_status(200)
    end

    it "returns the details of the specified certification type" do
      get "/api/v1/admin/certification_types/#{certification_type.id}", headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:certification_type][:id]).to eq(certification_type.id)
      expect(u[:certification_type][:name]).to eq(certification_type.name)
    end

  end

  describe "Certification Types Create" do
    
    it "returns http not authorized when not signed in" do
      certification_type_params      = { name: "BBPD" }
      certification_type_params_json = certification_type_params.to_json

      sign_out login_user
      post "/api/v1/admin/certification_types", params: certification_type_params_json, headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      certification_type_params      = { name: "BBPD" }
      certification_type_params_json = certification_type_params.to_json

      post "/api/v1/admin/certification_types/", params: certification_type_params_json, headers: @headers
      expect(response).to have_http_status(200)
    end

    it "is successful with valid parameters" do
      certification_type_params      = { name: "BBPD", effective_interval: 1, effective_interval_unit: "year" }
      certification_type_params_json = certification_type_params.to_json

      post "/api/v1/admin/certification_types", params: certification_type_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:certification_type][:name]).to eq(certification_type_params[:name])
      expect(u[:certification_type][:effective_interval]).to eq(certification_type_params[:effective_interval])
      expect(u[:certification_type][:effective_interval_unit]).to eq(certification_type_params[:effective_interval_unit])
    end

    it "is not successful without a name" do
      certification_type_params      = { name: nil, effective_interval: 1, effective_interval_unit: "year" }
      certification_type_params_json = certification_type_params.to_json

      post "/api/v1/admin/certification_types", params: certification_type_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:name]).to eq(["can't be blank"])
    end

    it "is not successful with a dupliate name" do
      certification_type_params      = create(:certification_type, name: "BBPD")
      certification_type_params_json = certification_type_params.to_json

      post "/api/v1/admin/certification_types", params: certification_type_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:name]).to eq(["has already been taken"])
    end

    it "is not successful without an effective interval" do
      certification_type_params      = { name: "BBPD", effective_interval: nil, effective_interval_unit: "year" }
      certification_type_params_json = certification_type_params.to_json

      post "/api/v1/admin/certification_types", params: certification_type_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:effective_interval]).to eq(["can't be blank"])
    end

    it "is not successful without an effective interval unit" do
      certification_type_params      = { name: "BBPD", effective_interval: 1, effective_interval_unit: nil }
      certification_type_params_json = certification_type_params.to_json

      post "/api/v1/admin/certification_types", params: certification_type_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:effective_interval_unit]).to eq(["can't be blank"])
    end
    
  end

  describe "Certification Types Update" do
    
    it "returns http not authorized when not signed in" do
      certification_type_params      = { name: "BBPD", effective_interval: 1, effective_interval_unit: "year" }
      certification_type_params_json = certification_type_params.to_json

      sign_out login_user
      patch "/api/v1/admin/certification_types/#{certification_type.id}", params: certification_type_params_json, headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      certification_type_params      = { name: "BBPD", effective_interval: 1, effective_interval_unit: "year" }
      certification_type_params_json = certification_type_params.to_json

      patch "/api/v1/admin/certification_types/#{certification_type.id}", params: certification_type_params_json, headers: @headers
      expect(response).to have_http_status(200)
    end

    it "is successful with valid parameters" do
      certification_type_params      = { name: "BBPD", effective_interval: 1, effective_interval_unit: "year" }
      certification_type_params_json = certification_type_params.to_json

      patch "/api/v1/admin/certification_types/#{certification_type.id}", params: certification_type_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:certification_type][:name]).to eq(certification_type_params[:name])
      expect(u[:certification_type][:effective_interval]).to eq(certification_type_params[:effective_interval])
      expect(u[:certification_type][:effective_interval_unit]).to eq(certification_type_params[:effective_interval_unit])
    end

    it "is not successful without a name" do
      certification_type_params      = { name: nil, effective_interval: 1, effective_interval_unit: "year" }
      certification_type_params_json = certification_type_params.to_json

      patch "/api/v1/admin/certification_types/#{certification_type.id}", params: certification_type_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:name]).to eq(["can't be blank"])
    end

    it "is not successful with a dupliate name" do
      certification_type_params      = create(:certification_type, name: "BBPD")
      certification_type_params_json = certification_type_params.to_json

      patch "/api/v1/admin/certification_types/#{certification_type.id}", params: certification_type_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:name]).to eq(["has already been taken"])
    end

    it "is not successful without an effective interval" do
      certification_type_params      = { name: "BBPD", effective_interval: nil, effective_interval_unit: "year" }
      certification_type_params_json = certification_type_params.to_json

      patch "/api/v1/admin/certification_types/#{certification_type.id}", params: certification_type_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:effective_interval]).to eq(["can't be blank"])
    end

    it "is not successful without an effective interval unit" do
      certification_type_params      = { name: "BBPD", effective_interval: 1, effective_interval_unit: nil }
      certification_type_params_json = certification_type_params.to_json

      patch "/api/v1/admin/certification_types/#{certification_type.id}", params: certification_type_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:effective_interval_unit]).to eq(["can't be blank"])
    end

  end

  describe "Certification Types Destroy" do
    
    it "returns http not authorized when not signed in" do
      sign_out login_user
      delete "/api/v1/admin/certification_types/#{certification_type.id}", headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      delete "/api/v1/admin/certification_types/#{certification_type.id}", headers: @headers
      expect(response).to have_http_status(200)
    end

    it "returns the list of certification types without the deleted certification type" do
      delete "/api/v1/admin/certification_types/#{certification_type.id}", headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:certification_types].any? { |value| certification_type }).to eq(false)
    end

  end

end
