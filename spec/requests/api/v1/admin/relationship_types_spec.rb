require 'rails_helper'

RSpec.describe Api::V1::Admin::RelationshipTypesController, type: :request do

  let(:random_name)        { generate_random_string(16) }
  let(:login_user)         { create(:user, :admin) }
  let(:relationship_type)  { create(:relationship_type, name: random_name) }

  before(:each) do
    @headers = { 'ACCEPT': 'application/json',  'CONTENT-TYPE': 'application/json' }
    sign_in login_user
  end

  describe "Relationship Types API Index" do
    
    it 'returns http not authorized when not signed in' do
      sign_out login_user
      get "/api/v1/admin/relationship_types", headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      get "/api/v1/admin/relationship_types", headers: @headers
      expect(response).to have_http_status(200)
    end

    it "returns the list of relationship types" do
      @relationship_types = []
      @relationship_types << build(:relationship_type, name: "Spouse")
      @relationship_types << build(:relationship_type, name: "Child")
      @relationship_types.sort!

      get "/api/v1/admin/relationship_types", headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      u[:relationship_types].each_with_index do |relationship_type, index|
        expect(relationship_type[:id]).to eq(@relationship_types[index].id)
        expect(relationship_type[:name]).to eq(@relationship_types[index].name)
      end
    end

  end

  describe "Relationship Types API Show" do
    
    it "returns http not authorized when not signed in" do
      sign_out login_user
      get "/api/v1/admin/relationship_types/#{relationship_type.id}", headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      get "/api/v1/admin/relationship_types/#{relationship_type.id}", headers: @headers
      expect(response).to have_http_status(200)
    end

    it "returns the details of the specified relationship type" do
      get "/api/v1/admin/relationship_types/#{relationship_type.id}", headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:relationship_type][:id]).to eq(relationship_type.id)
      expect(u[:relationship_type][:name]).to eq(relationship_type.name)
    end

  end

  describe "Relationship Types Create" do
    
    it "returns http not authorized when not signed in" do
      relationship_type_params      = { name: "Spouse" }
      relationship_type_params_json = relationship_type_params.to_json

      sign_out login_user
      post "/api/v1/admin/relationship_types", params: relationship_type_params_json, headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      relationship_type_params      = { name: "Spouse" }
      relationship_type_params_json = relationship_type_params.to_json

      post "/api/v1/admin/relationship_types/", params: relationship_type_params_json, headers: @headers
      expect(response).to have_http_status(200)
    end

    it "is successful with valid parameters" do
      relationship_type_params      = { name: "Spouse" }
      relationship_type_params_json = relationship_type_params.to_json

      post "/api/v1/admin/relationship_types", params: relationship_type_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:relationship_type][:name]).to eq(relationship_type_params[:name])
    end

    it "is not successful without a name" do
      relationship_type_params      = { name: nil }
      relationship_type_params_json = relationship_type_params.to_json

      post "/api/v1/admin/relationship_types", params: relationship_type_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:name]).to eq(["can't be blank"])
    end

    it "is not successful with a dupliate name" do
      relationship_type_params      = create(:relationship_type, name: "Spouse")
      relationship_type_params_json = relationship_type_params.to_json

      post "/api/v1/admin/relationship_types", params: relationship_type_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:name]).to eq(["has already been taken"])
    end
    
  end

  describe "Relationship Types Update" do
    
    it "returns http not authorized when not signed in" do
      relationship_type_params      = { name: "Spouse" }
      relationship_type_params_json = relationship_type_params.to_json

      sign_out login_user
      patch "/api/v1/admin/relationship_types/#{relationship_type.id}", params: relationship_type_params_json, headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      relationship_type_params      = { name: "Spouse" }
      relationship_type_params_json = relationship_type_params.to_json

      patch "/api/v1/admin/relationship_types/#{relationship_type.id}", params: relationship_type_params_json, headers: @headers
      expect(response).to have_http_status(200)
    end

    it "is successful with valid parameters" do
      relationship_type_params      = { name: "Spouse" }
      relationship_type_params_json = relationship_type_params.to_json

      patch "/api/v1/admin/relationship_types/#{relationship_type.id}", params: relationship_type_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:relationship_type][:name]).to eq(relationship_type_params[:name])
    end

    it "is not successful without a name" do
      relationship_type_params      = { name: nil }
      relationship_type_params_json = relationship_type_params.to_json

      patch "/api/v1/admin/relationship_types/#{relationship_type.id}", params: relationship_type_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:name]).to eq(["can't be blank"])
    end

    it "is not successful with a dupliate name" do
      relationship_type_params      = create(:relationship_type, name: "Spouse")
      relationship_type_params_json = relationship_type_params.to_json

      patch "/api/v1/admin/relationship_types/#{relationship_type.id}", params: relationship_type_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:name]).to eq(["has already been taken"])
    end

  end

  describe "Relationship Types Destroy" do
    
    it "returns http not authorized when not signed in" do
      sign_out login_user
      delete "/api/v1/admin/relationship_types/#{relationship_type.id}", headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      delete "/api/v1/admin/relationship_types/#{relationship_type.id}", headers: @headers
      expect(response).to have_http_status(200)
    end

    it "returns the list of relationship types without the deleted relationship type" do
      delete "/api/v1/admin/relationship_types/#{relationship_type.id}", headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:relationship_types].any? { |value| relationship_type }).to eq(false)
    end

  end

end
