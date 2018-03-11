require 'rails_helper'

RSpec.describe Api::V1::Admin::CompaniesController, type: :request do

  let(:login_user)  { create(:user, :admin) }
  let(:company)     { create(:company) }

  before(:each) do
    @headers = { 'ACCEPT': 'application/json',  'CONTENT-TYPE': 'application/json' }
    sign_in login_user
  end

  describe "Companies API Index " do

    it 'returns http not authorized when not signed in' do
      sign_out login_user
      get "/api/v1/admin/companies", headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      get "/api/v1/admin/companies", headers: @headers
      expect(response).to have_http_status(200)
    end

    it "returns the list of company" do
      @company = []
      @company << build(:company, name: "BOB'S BISCUITS")
      @company << build(:company, name: "KELLY'S KAKES")
      @company.sort!

      get "/api/v1/admin/companies", headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      u[:companies].each_with_index do |company, index|
        expect(company[:id]).to eq(@company[index].id)
        expect(company[:name]).to eq(@company[index].name)
      end
    end

  end

  describe "Companies API Show" do

    it "returns http not authorized when not signed in" do
      company_params      = { name: "KELLY'S KAKES" }
      company_params_json = company_params.to_json

      sign_out login_user
      get "/api/v1/admin/companies/#{company.id}", params: company_params_json, headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      company_params      = { name: "KELLY'S KAKES" }
      company_params_json = company_params.to_json

      get "/api/v1/admin/companies/#{company.id}", params: company_params_json, headers: @headers
      expect(response).to have_http_status(200)
    end

    it "returns the details of the specified company" do
      company_params      = { name: "KELLY'S KAKES" }
      company_params_json = company_params.to_json

      get "/api/v1/admin/companies/#{company.id}", params: company_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:company][:id]).to eq(company.id)
      expect(u[:company][:name]).to eq(company.name)
    end

  end

  describe "Companies API Create" do

    it "returns http not authorized when not signed in" do
      company_params      = { name: "BOB'S BISCUITS" }
      company_params_json = company_params.to_json

      sign_out login_user
      post "/api/v1/admin/companies", params: company_params_json, headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      company_params      = { name: "BOB'S BISCUITS" }
      company_params_json = company_params.to_json

      post "/api/v1/admin/companies/", params: company_params_json, headers: @headers
      expect(response).to have_http_status(200)
    end

    it "is successful with valid parameters" do
      company_params      = { name: "BOB'S BISCUITS" }
      company_params_json = company_params.to_json

      post "/api/v1/admin/companies", params: company_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:company][:name]).to eq(company_params[:name])
    end

    it "is not successful without a name" do
      company_params      = { name: nil }
      company_params_json = company_params.to_json

      post "/api/v1/admin/companies", params: company_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:name]).to eq(["can't be blank"])
    end

    it "is not successful with a dupliate name" do
      company_params    = create(:company, name: "BOB'S BISCUITS")
      company_params_json = company_params.to_json

      post "/api/v1/admin/companies", params: company_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:name]).to eq(["has already been taken"])
    end

  end

  describe "Companies API Update" do

    it "returns http not authorized when not signed in" do
      company_params      = { name: "KELLY'S KAKES" }
      company_params_json = company_params.to_json

      sign_out login_user
      patch "/api/v1/admin/companies/#{company.id}", params: company_params_json, headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      company_params      = { name: "KELLY'S KAKES" }
      company_params_json = company_params.to_json

      patch "/api/v1/admin/companies/#{company.id}", params: company_params_json, headers: @headers
      expect(response).to have_http_status(200)
    end

    it "is successful with valid parameters" do
      company_params      = { name: "KELLY'S KAKES" }
      company_params_json = company_params.to_json

      patch "/api/v1/admin/companies/#{company.id}", params: company_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:company][:name]).to eq(company_params[:name])
    end

    it "is not successful without a name" do
      company_params      = { name: nil }
      company_params_json = company_params.to_json

      patch "/api/v1/admin/companies/#{company.id}", params: company_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:name]).to eq(["can't be blank"])
    end

    it "is not successful with a duplicate name" do
      company_params      = create(:company)
      company_params_json = company_params.to_json

      patch "/api/v1/admin/companies/#{company.id}", params: company_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:name]).to eq(["has already been taken"])
    end

  end

  describe "Companies API Destroy" do

    it "returns http not authorized when not signed in" do
      sign_out login_user
      delete "/api/v1/admin/companies/#{company.id}", headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      delete "/api/v1/admin/companies/#{company.id}", headers: @headers
      expect(response).to have_http_status(200)
    end

    it "returns the list of company without the deleted company" do
      delete "/api/v1/admin/companies/#{company.id}", headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:companies].any? { |value| company }).to eq(false)
    end

  end

end
