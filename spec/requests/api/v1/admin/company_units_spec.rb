require 'rails_helper'

RSpec.describe Api::V1::Admin::CompanyUnitsController, type: :request do

  let(:login_user)    { create(:user, :admin) }
  let(:manager)       { create(:employee) }
  let(:company)       { create(:company) }
  let(:company_unit)  { create(:company_unit, company: company) }

  before(:each) do
    @headers = { 'ACCEPT': 'application/json',  'CONTENT-TYPE': 'application/json' }
    sign_in login_user
  end

  describe "Company Units API Index " do

    it 'returns http not authorized when not signed in' do
      sign_out login_user
      get "/api/v1/admin/company_units", headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      get "/api/v1/admin/company_units", headers: @headers
      expect(response).to have_http_status(200)
    end

    it "returns the list of company units" do
      @company_unit = []
      @company_unit << build(:company_unit, company: company)
      @company_unit << build(:company_unit, company: company)
      @company_unit.sort!

      get "/api/v1/admin/company_units", headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      u[:company_units].each_with_index do |company_unit, index|
        expect(company_unit[:id]).to eq(@company_unit[index].id)
        expect(company_unit[:name]).to eq(@company_unit[index].name)
      end
    end

  end

  describe "Company Units API Show" do

    it "returns http not authorized when not signed in" do
      company_unit_params      = { name: "HUMAN RESOURCES", company_id: company.id, manager: manager.id }
      company_unit_params_json = company_unit_params.to_json

      sign_out login_user
      get "/api/v1/admin/company_units/#{company_unit.id}", params: company_unit_params_json, headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      company_unit_params      = { name: "HUMAN RESOURCES", company_id: company.id, manager: manager.id }
      company_unit_params_json = company_unit_params.to_json

      get "/api/v1/admin/company_units/#{company_unit.id}", params: company_unit_params_json, headers: @headers
      expect(response).to have_http_status(200)
    end

    it "returns the details of the specified company_unit" do
      company_unit_params      = { name: "HUMAN RESOURCES", company_id: company.id, manager: manager.id }
      company_unit_params_json = company_unit_params.to_json

      get "/api/v1/admin/company_units/#{company_unit.id}", params: company_unit_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:company_unit][:id]).to eq(company_unit.id)
      expect(u[:company_unit][:name]).to eq(company_unit.name)
    end

  end

  describe "Company Units API Create" do

    it "returns http not authorized when not signed in" do
      company_unit_params      = { name: "HUMAN RESOURCES", company_id: company.id, manager: manager.id }
      company_unit_params_json = company_unit_params.to_json

      sign_out login_user
      post "/api/v1/admin/company_units", params: company_unit_params_json, headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      company_unit_params      = { name: "HUMAN RESOURCES", company_id: company.id, manager: manager.id }
      company_unit_params_json = company_unit_params.to_json

      post "/api/v1/admin/company_units/", params: company_unit_params_json, headers: @headers
      expect(response).to have_http_status(200)
    end

    it "is successful with valid parameters" do
      company_unit_params      = { name: "HUMAN RESOURCES", company_id: company.id, manager: manager.id }
      company_unit_params_json = company_unit_params.to_json

      post "/api/v1/admin/company_units", params: company_unit_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:company_unit][:name]).to eq(company_unit_params[:name])
    end

    it "is not successful without a name" do
      company_unit_params      = { name: nil, company_id: company.id, manager: manager.id }
      company_unit_params_json = company_unit_params.to_json

      post "/api/v1/admin/company_units", params: company_unit_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:name]).to eq(["can't be blank"])
    end

    it "returns http not found without a company" do
      company_unit_params      = { name: "HUMAN RESOURCES", company_id: nil, manager: manager.id }
      company_unit_params_json = company_unit_params.to_json

      post "/api/v1/admin/company_units", params: company_unit_params_json, headers: @headers
      expect(response).to have_http_status(404)
    end

  end

  describe "Company Units API Update" do

    it "returns http not authorized when not signed in" do
      company_unit_params      = { name: "HUMAN RESOURCES", company_id: company.id, manager: manager.id }
      company_unit_params_json = company_unit_params.to_json

      sign_out login_user
      patch "/api/v1/admin/company_units/#{company_unit.id}", params: company_unit_params_json, headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      company_unit_params      = { name: "HUMAN RESOURCES", company_id: company.id, manager: manager.id }
      company_unit_params_json = company_unit_params.to_json

      patch "/api/v1/admin/company_units/#{company_unit.id}/", params: company_unit_params_json, headers: @headers
      expect(response).to have_http_status(200)
    end

    it "is successful with valid parameters" do
      company_unit_params      = { name: "HUMAN RESOURCES", company_id: company.id, manager: manager.id }
      company_unit_params_json = company_unit_params.to_json

      patch "/api/v1/admin/company_units/#{company_unit.id}", params: company_unit_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:company_unit][:name]).to eq(company_unit_params[:name])
    end

    it "is not successful without a name" do
      company_unit_params      = { name: nil, company_id: company.id, manager: manager.id }
      company_unit_params_json = company_unit_params.to_json

      patch "/api/v1/admin/company_units/#{company_unit.id}", params: company_unit_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:name]).to eq(["can't be blank"])
    end

    it "returns http not found without a company" do
      company_unit_params      = { name: "HUMAN RESOURCES", company_id: nil, manager: manager.id }
      company_unit_params_json = company_unit_params.to_json

      patch "/api/v1/admin/company_units/#{company_unit.id}", params: company_unit_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:company]).to eq(["must exist"])
    end

  end

  describe "Company Unit API Destroy" do

    it "returns http not authorized when not signed in" do
      sign_out login_user
      delete "/api/v1/admin/company_units/#{company_unit.id}", headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      delete "/api/v1/admin/company_units/#{company_unit.id}", headers: @headers
      expect(response).to have_http_status(200)
    end

    it "returns the list of company units without the deleted company unit" do
      delete "/api/v1/admin/company_units/#{company_unit.id}", headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:company_units].any? { |value| company_unit }).to eq(false)
    end

  end

end
