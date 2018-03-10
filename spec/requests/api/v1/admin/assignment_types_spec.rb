require 'rails_helper'

RSpec.describe Api::V1::Admin::AssignmentTypesController, type: :request do

  let(:login_user)            { create(:user, :admin) }
  let(:assignment_type)       { create(:assignment_type) }

  before(:each) do
    @headers = { 'ACCEPT': 'application/json',  'CONTENT-TYPE': 'application/json' }
    sign_in login_user
  end

  describe "Assignment Types API Index" do
    
    it 'returns http not authorized when not signed in' do
      sign_out login_user
      get "/api/v1/admin/assignment_types", headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      get "/api/v1/admin/assignment_types", headers: @headers
      expect(response).to have_http_status(200)
    end

    it "returns the list of assignment types" do
      @assignment_types = []
      @assignment_types << build(:assignment_type, name: "FRONT DESK REPRESENTATIVE")
      @assignment_types << build(:assignment_type, name: "SCHEDULER")
      @assignment_types.sort!

      get "/api/v1/admin/assignment_types", headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      u[:assignment_types].each_with_index do |assignment_type, index|
        expect(assignment_type[:id]).to eq(@assignment_types[index].id)
        expect(assignment_type[:name]).to eq(@assignment_types[index].name)
      end
    end

  end

  describe "Assignment Types API Show" do
    
    it "returns http not authorized when not signed in" do
      sign_out login_user
      get "/api/v1/admin/assignment_types/#{assignment_type.id}", headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      get "/api/v1/admin/assignment_types/#{assignment_type.id}", headers: @headers
      expect(response).to have_http_status(200)
    end

    it "returns the details of the specified assignment type" do
      get "/api/v1/admin/assignment_types/#{assignment_type.id}", headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:assignment_type][:id]).to eq(assignment_type.id)
      expect(u[:assignment_type][:name]).to eq(assignment_type.name)
    end

  end

  describe "Assignment Types Create" do
    
    it "returns http not authorized when not signed in" do
      assignment_type_params      = { name: "SCREENER" }
      assignment_type_params_json = assignment_type_params.to_json

      sign_out login_user
      post "/api/v1/admin/assignment_types", params: assignment_type_params_json, headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      assignment_type_params      = { name: "SCREENER" }
      assignment_type_params_json = assignment_type_params.to_json

      post "/api/v1/admin/assignment_types/", params: assignment_type_params_json, headers: @headers
      expect(response).to have_http_status(200)
    end

    it "is successful with valid parameters" do
      assignment_type_params      = { name: "SCREENER" }
      assignment_type_params_json = assignment_type_params.to_json

      post "/api/v1/admin/assignment_types", params: assignment_type_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:assignment_type][:name]).to eq(assignment_type_params[:name])
    end

    it "is not successful without a name" do
      assignment_type_params      = { name: nil }
      assignment_type_params_json = assignment_type_params.to_json

      post "/api/v1/admin/assignment_types", params: assignment_type_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:name]).to eq(["can't be blank"])
    end

    it "is not successful with a dupliate name" do
      assignment_type_params      = create(:assignment_type, name: "SCREENER")
      assignment_type_params_json = assignment_type_params.to_json

      post "/api/v1/admin/assignment_types", params: assignment_type_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:name]).to eq(["has already been taken"])
    end
    
  end

  describe "Assignment Types Update" do
    
    it "returns http not authorized when not signed in" do
      assignment_type_params      = { name: "SCHEDULER" }
      assignment_type_params_json = assignment_type_params.to_json

      sign_out login_user
      patch "/api/v1/admin/assignment_types/#{assignment_type.id}", params: assignment_type_params_json, headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      assignment_type_params      = { name: "SCHEDULER" }
      assignment_type_params_json = assignment_type_params.to_json

      patch "/api/v1/admin/assignment_types/#{assignment_type.id}", params: assignment_type_params_json, headers: @headers
      expect(response).to have_http_status(200)
    end

    it "is successful with valid parameters" do
      assignment_type_params      = { name: "SCHEDULER" }
      assignment_type_params_json = assignment_type_params.to_json

      patch "/api/v1/admin/assignment_types/#{assignment_type.id}", params: assignment_type_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:assignment_type][:name]).to eq(assignment_type_params[:name])
    end

    it "is not successful without a name" do
      assignment_type_params      = { name: nil }
      assignment_type_params_json = assignment_type_params.to_json

      patch "/api/v1/admin/assignment_types/#{assignment_type.id}", params: assignment_type_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:name]).to eq(["can't be blank"])
    end

    it "is not successful with a dupliate name" do
      assignment_type_params      = create(:assignment_type, name: "SCHEDULER")
      assignment_type_params_json = assignment_type_params.to_json

      patch "/api/v1/admin/assignment_types/#{assignment_type.id}", params: assignment_type_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:name]).to eq(["has already been taken"])
    end

  end

  describe "Assignment Types Destroy" do
    
    it "returns http not authorized when not signed in" do
      sign_out login_user
      delete "/api/v1/admin/assignment_types/#{assignment_type.id}", headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      delete "/api/v1/admin/assignment_types/#{assignment_type.id}", headers: @headers
      expect(response).to have_http_status(200)
    end

    it "returns the list of assignment types without the deleted assignment type" do
      delete "/api/v1/admin/assignment_types/#{assignment_type.id}", headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:assignment_types].any? { |value| assignment_type }).to eq(false)
    end

  end

end
