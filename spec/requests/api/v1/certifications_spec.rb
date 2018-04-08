require 'rails_helper'

RSpec.describe Api::V1::CertificationsController, type: :request do

  let(:random_name)         { generate_random_string(16) }
  let(:login_user)          { create(:user) }
  let(:person)              { create(:person) }
  let(:employee)            { create(:employee, person: person) }
  let(:certification)       { create(:certification, person: person) }
  let(:certification_type)  { create(:certification_type, name: random_name) }

  before(:each) do
    @headers = { 'ACCEPT': 'application/json',  'CONTENT-TYPE': 'application/json' }
    sign_in login_user
  end

  describe "Certifications API Index " do

    it 'returns http not authorized when not signed in' do
      sign_out login_user
      get "/api/v1/people/#{person.id}/certifications", headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      get "/api/v1/people/#{person.id}/certifications", headers: @headers
      expect(response).to have_http_status(200)
    end

    it "returns the list of certifications" do
      @certifications = []
      @certifications << build(:certification, person: person)
      @certifications << build(:certification, person: person)
      @certifications.sort!

      get "/api/v1/people/#{person.id}/certifications", headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      u[:certifications].each_with_index do |certification, index|
        expect(certification[:id]).to eq(@certifications[index].id)
        expect(certification[:person_id]).to eq(@certifications[index].person_id)
        expect(certification[:certification_type_id]).to eq(@certifications[index].certification_type_id)
        expect(certification[:certification_number]).to eq(@certifications[index].certification_number)
        expect(certification[:renewed_at]).to eq(@certifications[index].renewed_at)
        expect(certification[:expires_at]).to eq(@certifications[index].expires_at)
        expect(certification[:updated_by]).to eq(@certifications[index].updated_by)
      end
    end

  end

  describe "Certifications API Show" do

    it "returns http not authorized when not signed in" do
      certification_params      = {
                                    person_id: person.id,
                                    certification_type_id: certification_type.id,
                                    certification_number: Faker::Lorem.word,
                                    renewed_at: Date.today,
                                    expires_at: Date.today,
                                    updated_by: employee.id
                                  }
      certification_params_json = certification_params.to_json

      sign_out login_user
      get "/api/v1/people/#{person.id}/certifications/#{certification.id}", params: certification_params_json, headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      certification_params      = {
                                    person_id: person.id,
                                    certification_type_id: certification_type.id,
                                    certification_number: Faker::Lorem.word,
                                    renewed_at: Date.today,
                                    expires_at: Date.today,
                                    updated_by: employee.id
                                  }
      certification_params_json = certification_params.to_json

      get "/api/v1/people/#{person.id}/certifications/#{certification.id}", params: certification_params_json, headers: @headers
      expect(response).to have_http_status(200)
    end

    it "returns the details of the specified certification" do
      certification_params      = {
                                    person_id: person.id,
                                    certification_type_id: certification_type.id,
                                    certification_number: Faker::Lorem.word,
                                    renewed_at: Date.today,
                                    expires_at: Date.today,
                                    updated_by: employee.id
                                  }
      certification_params_json = certification_params.to_json

      get "/api/v1/people/#{person.id}/certifications/#{certification.id}", params: certification_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:certification][:id]).to eq(certification.id)
      expect(u[:certification][:person_id]).to eq(certification.person_id)
      expect(u[:certification][:certification_type_id]).to eq(certification.certification_type_id)
      expect(u[:certification][:certification_number]).to eq(certification.certification_number)
      expect(u[:certification][:renewed_at]).to eq(certification.renewed_at.strftime("%Y-%m-%d"))
      expect(u[:certification][:expires_at]).to eq(certification.expires_at.strftime("%Y-%m-%d"))
      expect(u[:certification][:updated_by]).to eq(certification.updated_by)
    end

  end

  describe "Certifications API Create" do

    it "returns http not authorized when not signed in" do
      certification_params      = {
                                    person_id: person.id,
                                    certification_type_id: certification_type.id,
                                    certification_number: Faker::Lorem.word,
                                    renewed_at: Date.today,
                                    expires_at: Date.today,
                                    updated_by: employee.id
                                  }
      certification_params_json = certification_params.to_json

      sign_out login_user
      post "/api/v1/people/#{person.id}/certifications", params: certification_params_json, headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      certification_params      = {
                                    person_id: person.id,
                                    certification_type_id: certification_type.id,
                                    certification_number: Faker::Lorem.word,
                                    renewed_at: Date.today,
                                    expires_at: Date.today,
                                    updated_by: employee.id
                                  }
      certification_params_json = certification_params.to_json

      post "/api/v1/people/#{person.id}/certifications/", params: certification_params_json, headers: @headers
      expect(response).to have_http_status(200)
    end

    it "is successful with valid parameters" do
      certification_params      = {
                                    person_id: person.id,
                                    certification_type_id: certification_type.id,
                                    certification_number: Faker::Lorem.word,
                                    renewed_at: Date.today,
                                    expires_at: Date.today,
                                    updated_by: employee.id
                                  }
      certification_params_json = certification_params.to_json

      post "/api/v1/people/#{person.id}/certifications", params: certification_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:certification][:person_id]).to eq(certification_params[:person_id])
      expect(u[:certification][:certification_type_id]).to eq(certification_params[:certification_type_id])
      expect(u[:certification][:certification_number]).to eq(certification_params[:certification_number])
      expect(u[:certification][:renewed_at]).to eq(certification_params[:renewed_at].strftime("%Y-%m-%d"))
      expect(u[:certification][:expires_at]).to eq(certification_params[:expires_at].strftime("%Y-%m-%d"))
      expect(u[:certification][:updated_by]).to eq(certification_params[:updated_by])
    end

  end

  describe "Certifications API Update" do

    it "returns http not authorized when not signed in" do
      certification_params      = {
                                    person_id: person.id,
                                    certification_type_id: certification_type.id,
                                    certification_number: Faker::Lorem.word,
                                    renewed_at: Date.today,
                                    expires_at: Date.today,
                                    updated_by: employee.id
                                  }
      certification_params_json = certification_params.to_json

      sign_out login_user
      patch "/api/v1/people/#{person.id}/certifications/#{certification.id}", params: certification_params_json, headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      certification_params      = {
                                    person_id: person.id,
                                    certification_type_id: certification_type.id,
                                    certification_number: Faker::Lorem.word,
                                    renewed_at: Date.today,
                                    expires_at: Date.today,
                                    updated_by: employee.id
                                  }
      certification_params_json = certification_params.to_json

      patch "/api/v1/people/#{person.id}/certifications/#{certification.id}", params: certification_params_json, headers: @headers
      expect(response).to have_http_status(200)
    end

    it "is successful with valid parameters" do
      certification_params      = {
                                    person_id: person.id,
                                    certification_type_id: certification_type.id,
                                    certification_number: Faker::Lorem.word,
                                    renewed_at: Date.today,
                                    expires_at: Date.today,
                                    updated_by: employee.id
                                  }
      certification_params_json = certification_params.to_json

      patch "/api/v1/people/#{person.id}/certifications/#{certification.id}", params: certification_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:certification][:person_id]).to eq(certification_params[:person_id])
      expect(u[:certification][:certification_type_id]).to eq(certification_params[:certification_type_id])
      expect(u[:certification][:certification_number]).to eq(certification_params[:certification_number])
      expect(u[:certification][:renewed_at]).to eq(certification_params[:renewed_at].strftime("%Y-%m-%d"))
      expect(u[:certification][:expires_at]).to eq(certification_params[:expires_at].strftime("%Y-%m-%d"))
      expect(u[:certification][:updated_by]).to eq(certification_params[:updated_by])
    end

  end

  describe "Certifications API Destroy" do

    it "returns http not authorized when not signed in" do
      sign_out login_user
      delete "/api/v1/people/#{person.id}/certifications/#{certification.id}", headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      delete "/api/v1/people/#{person.id}/certifications/#{certification.id}", headers: @headers
      expect(response).to have_http_status(200)
    end

    it "returns the list of certifications without the deleted certification" do
      delete "/api/v1/people/#{person.id}/certifications/#{certification.id}", headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:certifications].any? { |value| certification }).to eq(false)
    end

  end

end
