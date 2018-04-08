require 'rails_helper'

RSpec.describe Api::V1::Admin::ContactTypesController, type: :request do

  let(:random_name)   { generate_random_string(16) }
  let(:login_user)    { create(:user, :admin) }
  let(:contact_type)  { create(:contact_type, name: random_name) }

  before(:each) do
    @headers = { 'ACCEPT': 'application/json',  'CONTENT-TYPE': 'application/json' }
    sign_in login_user
  end

  describe "Contact Types API Index" do
    
    it 'returns http not authorized when not signed in' do
      sign_out login_user
      get "/api/v1/admin/contact_types", headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      get "/api/v1/admin/contact_types", headers: @headers
      expect(response).to have_http_status(200)
    end

    it "returns the list of contact types" do
      @contact_types = []
      @contact_types << build(:contact_type, name: "EMAIL")
      @contact_types << build(:contact_type, name: "HOME PHONE")
      @contact_types.sort!

      get "/api/v1/admin/contact_types", headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      u[:contact_types].each_with_index do |contact_type, index|
        expect(contact_type[:id]).to eq(@contact_types[index].id)
        expect(contact_type[:name]).to eq(@contact_types[index].name)
      end
    end

  end

  describe "Contact Types API Show" do
    
    it "returns http not authorized when not signed in" do
      sign_out login_user
      get "/api/v1/admin/contact_types/#{contact_type.id}", headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      get "/api/v1/admin/contact_types/#{contact_type.id}", headers: @headers
      expect(response).to have_http_status(200)
    end

    it "returns the details of the specified contact type" do
      get "/api/v1/admin/contact_types/#{contact_type.id}", headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:contact_type][:id]).to eq(contact_type.id)
      expect(u[:contact_type][:name]).to eq(contact_type.name)
    end

  end

  describe "Contact Types Create" do
    
    it "returns http not authorized when not signed in" do
      contact_type_params      = { name: "EMAIL" }
      contact_type_params_json = contact_type_params.to_json

      sign_out login_user
      post "/api/v1/admin/contact_types", params: contact_type_params_json, headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      contact_type_params      = { name: "EMAIL" }
      contact_type_params_json = contact_type_params.to_json

      post "/api/v1/admin/contact_types/", params: contact_type_params_json, headers: @headers
      expect(response).to have_http_status(200)
    end

    it "is successful with valid parameters" do
      contact_type_params      = { name: "EMAIL" }
      contact_type_params_json = contact_type_params.to_json

      post "/api/v1/admin/contact_types", params: contact_type_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:contact_type][:name]).to eq(contact_type_params[:name])
    end

    it "is not successful without a name" do
      contact_type_params      = { name: nil }
      contact_type_params_json = contact_type_params.to_json

      post "/api/v1/admin/contact_types", params: contact_type_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:name]).to eq(["can't be blank"])
    end

    it "is not successful with a dupliate name" do
      contact_type_params      = create(:contact_type, name: "EMAIL")
      contact_type_params_json = contact_type_params.to_json

      post "/api/v1/admin/contact_types", params: contact_type_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:name]).to eq(["has already been taken"])
    end
    
  end

  describe "Contact Types Update" do
    
    it "returns http not authorized when not signed in" do
      contact_type_params      = { name: "EMAIL" }
      contact_type_params_json = contact_type_params.to_json

      sign_out login_user
      patch "/api/v1/admin/contact_types/#{contact_type.id}", params: contact_type_params_json, headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      contact_type_params      = { name: "EMAIL" }
      contact_type_params_json = contact_type_params.to_json

      patch "/api/v1/admin/contact_types/#{contact_type.id}", params: contact_type_params_json, headers: @headers
      expect(response).to have_http_status(200)
    end

    it "is successful with valid parameters" do
      contact_type_params      = { name: "EMAIL" }
      contact_type_params_json = contact_type_params.to_json

      patch "/api/v1/admin/contact_types/#{contact_type.id}", params: contact_type_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:contact_type][:name]).to eq(contact_type_params[:name])
    end

    it "is not successful without a name" do
      contact_type_params      = { name: nil }
      contact_type_params_json = contact_type_params.to_json

      patch "/api/v1/admin/contact_types/#{contact_type.id}", params: contact_type_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:name]).to eq(["can't be blank"])
    end

    it "is not successful with a dupliate name" do
      contact_type_params      = create(:contact_type, name: "EMAIL")
      contact_type_params_json = contact_type_params.to_json

      patch "/api/v1/admin/contact_types/#{contact_type.id}", params: contact_type_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:name]).to eq(["has already been taken"])
    end

  end

  describe "Contact Types Destroy" do
    
    it "returns http not authorized when not signed in" do
      sign_out login_user
      delete "/api/v1/admin/contact_types/#{contact_type.id}", headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      delete "/api/v1/admin/contact_types/#{contact_type.id}", headers: @headers
      expect(response).to have_http_status(200)
    end

    it "returns the list of contact types without the deleted contact type" do
      delete "/api/v1/admin/contact_types/#{contact_type.id}", headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:contact_types].any? { |value| contact_type }).to eq(false)
    end

  end

end
