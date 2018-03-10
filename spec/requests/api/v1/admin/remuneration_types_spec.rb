require 'rails_helper'

RSpec.describe Api::V1::Admin::RemunerationTypesController, type: :request do

  let(:login_user) { create(:user, :admin) }
  let(:remuneration_type)       { create(:remuneration_type) }

  before(:each) do
    @headers = { 'ACCEPT': 'application/json',  'CONTENT-TYPE': 'application/json' }
    sign_in login_user
  end

  describe "Remuneration Types API Index" do
    
    it 'returns http not authorized when not signed in' do
      sign_out login_user
      get "/api/v1/admin/remuneration_types", headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      get "/api/v1/admin/remuneration_types", headers: @headers
      expect(response).to have_http_status(200)
    end

    it "returns the list of remuneration types" do
      @remuneration_types = []
      @remuneration_types << build(:remuneration_type, name: "Hourly")
      @remuneration_types << build(:remuneration_type, name: "Contact")
      @remuneration_types.sort!

      get "/api/v1/admin/remuneration_types", headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      u[:remuneration_types].each_with_index do |remuneration_type, index|
        expect(remuneration_type[:id]).to eq(@remuneration_types[index].id)
        expect(remuneration_type[:name]).to eq(@remuneration_types[index].name)
        expect(remuneration_type[:pay_period_hours]).to eq(@remuneration_types[index].pay_period_hours)
        expect(remuneration_type[:annual_pay_periods]).to eq(@remuneration_types[index].annual_pay_periods)
      end
    end

  end

  describe "Remuneration Types API Show" do
    
    it "returns http not authorized when not signed in" do
      sign_out login_user
      get "/api/v1/admin/remuneration_types/#{remuneration_type.id}", headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      get "/api/v1/admin/remuneration_types/#{remuneration_type.id}", headers: @headers
      expect(response).to have_http_status(200)
    end

    it "returns the details of the specified remuneration type" do
      get "/api/v1/admin/remuneration_types/#{remuneration_type.id}", headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:remuneration_type][:id]).to eq(remuneration_type.id)
      expect(u[:remuneration_type][:name]).to eq(remuneration_type.name)
      expect(u[:remuneration_type][:pay_period_hours]).to eq(remuneration_type.pay_period_hours)
      expect(u[:remuneration_type][:annual_pay_periods]).to eq(remuneration_type.annual_pay_periods)
    end

  end

  describe "Remuneration Types Create" do
    
    it "returns http not authorized when not signed in" do
      remuneration_type_params      = { name: "Salary", pay_period_hours: 80, annual_pay_periods: 26 }
      remuneration_type_params_json = remuneration_type_params.to_json

      sign_out login_user
      post "/api/v1/admin/remuneration_types", params: remuneration_type_params_json, headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      remuneration_type_params      = { name: "Salary", pay_period_hours: 80, annual_pay_periods: 26 }
      remuneration_type_params_json = remuneration_type_params.to_json

      post "/api/v1/admin/remuneration_types/", params: remuneration_type_params_json, headers: @headers
      expect(response).to have_http_status(200)
    end

    it "is successful with valid parameters" do
      remuneration_type_params      = { name: "Salary", pay_period_hours: 80, annual_pay_periods: 26 }
      remuneration_type_params_json = remuneration_type_params.to_json

      post "/api/v1/admin/remuneration_types", params: remuneration_type_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:remuneration_type][:name]).to eq(remuneration_type_params[:name])
    end

    it "is not successful without a name" do
      remuneration_type_params      = { name: nil, pay_period_hours: 80, annual_pay_periods: 26 }
      remuneration_type_params_json = remuneration_type_params.to_json

      post "/api/v1/admin/remuneration_types", params: remuneration_type_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:name]).to eq(["can't be blank"])
    end

    it "is not successful with a dupliate name" do
      remuneration_type_params      = create(:remuneration_type, name: "Hourly")
      remuneration_type_params_json = remuneration_type_params.to_json

      post "/api/v1/admin/remuneration_types", params: remuneration_type_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:name]).to eq(["has already been taken"])
    end

    it "is not successful without pay period hours" do
      remuneration_type_params      = { name: nil, pay_period_hours: nil, annual_pay_periods: 26 }
      remuneration_type_params_json = remuneration_type_params.to_json

      post "/api/v1/admin/remuneration_types", params: remuneration_type_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:pay_period_hours]).to eq(["can't be blank"])
    end

    it "is not successful without annual pay periods" do
      remuneration_type_params      = { name: nil, pay_period_hours: 80, annual_pay_periods: nil }
      remuneration_type_params_json = remuneration_type_params.to_json

      post "/api/v1/admin/remuneration_types", params: remuneration_type_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:annual_pay_periods]).to eq(["can't be blank"])
    end
    
  end

  describe "Remuneration Types Update" do
    
    it "returns http not authorized when not signed in" do
      remuneration_type_params      = { name: "Salary", pay_period_hours: 80, annual_pay_periods: 26 }
      remuneration_type_params_json = remuneration_type_params.to_json

      sign_out login_user
      patch "/api/v1/admin/remuneration_types/#{remuneration_type.id}", params: remuneration_type_params_json, headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      remuneration_type_params      = { name: "Salary", pay_period_hours: 80, annual_pay_periods: 26 }
      remuneration_type_params_json = remuneration_type_params.to_json

      patch "/api/v1/admin/remuneration_types/#{remuneration_type.id}", params: remuneration_type_params_json, headers: @headers
      expect(response).to have_http_status(200)
    end

    it "is successful with valid parameters" do
      remuneration_type_params      = { name: "Salary", pay_period_hours: 80, annual_pay_periods: 26 }
      remuneration_type_params_json = remuneration_type_params.to_json

      patch "/api/v1/admin/remuneration_types/#{remuneration_type.id}", params: remuneration_type_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:remuneration_type][:name]).to eq(remuneration_type_params[:name])
    end

    it "is not successful without a name" do
      remuneration_type_params      = { name: nil, pay_period_hours: 80, annual_pay_periods: 26 }
      remuneration_type_params_json = remuneration_type_params.to_json

      patch "/api/v1/admin/remuneration_types/#{remuneration_type.id}", params: remuneration_type_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:name]).to eq(["can't be blank"])
    end

    it "is not successful with a dupliate name" do
      remuneration_type_params      = create(:remuneration_type, name: "Contract")
      remuneration_type_params_json = remuneration_type_params.to_json

      patch "/api/v1/admin/remuneration_types/#{remuneration_type.id}", params: remuneration_type_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:name]).to eq(["has already been taken"])
    end

    it "is not successful without pay period hours" do
      remuneration_type_params      = { name: "Salary", pay_period_hours: nil, annual_pay_periods: 26 }
      remuneration_type_params_json = remuneration_type_params.to_json

      patch "/api/v1/admin/remuneration_types/#{remuneration_type.id}", params: remuneration_type_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:pay_period_hours]).to eq(["can't be blank"])
    end

    it "is not successful without annual pay periods" do
      remuneration_type_params      = { name: "Salary", pay_period_hours: 80, annual_pay_periods: nil }
      remuneration_type_params_json = remuneration_type_params.to_json

      patch "/api/v1/admin/remuneration_types/#{remuneration_type.id}", params: remuneration_type_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:annual_pay_periods]).to eq(["can't be blank"])
    end

  end

  describe "Remuneration Types Destroy" do
    
    it "returns http not authorized when not signed in" do
      sign_out login_user
      delete "/api/v1/admin/remuneration_types/#{remuneration_type.id}", headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      delete "/api/v1/admin/remuneration_types/#{remuneration_type.id}", headers: @headers
      expect(response).to have_http_status(200)
    end

    it "returns the list of remuneration types without the deleted remuneration type" do
      delete "/api/v1/admin/remuneration_types/#{remuneration_type.id}", headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:remuneration_types].any? { |value| remuneration_type }).to eq(false)
    end

  end

end
