require 'rails_helper'

RSpec.describe Api::V1::EmergencyContactsController, type: :request do

  let(:random_name)      { generate_random_string(16) }
  let(:login_user)        { create(:user) }
  let(:person)            { create(:person) }
  let(:relationship_type) { create(:relationship_type, name: random_name) }
  let(:contact_type)      { create(:contact_type) }
  let(:emergency_contact) { create(
                                    :emergency_contact,
                                    person: person,
                                    contact_type: contact_type,
                                    relationship_type: relationship_type
                                  ) }

  before(:each) do
    @headers = { 'ACCEPT': 'application/json',  'CONTENT-TYPE': 'application/json' }
    sign_in login_user
  end

  describe "Emergency Contacts API Index " do

    it 'returns http not authorized when not signed in' do
      sign_out login_user
      get "/api/v1/people/#{person.id}/emergency_contacts", headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      get "/api/v1/people/#{person.id}/emergency_contacts", headers: @headers
      expect(response).to have_http_status(200)
    end

    it "returns the list of emergency contacts" do
      @emergency_contacts = []
      @emergency_contacts << build(:emergency_contact, person: person)
      @emergency_contacts << build(:emergency_contact, person: person)
      @emergency_contacts.sort!

      get "/api/v1/people/#{person.id}/emergency_contacts", headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      u[:emergency_contacts].each_with_index do |emergency_contact, index|
        expect(emergency_contact[:id]).to eq(@emergency_contacts[index].id)
        expect(emergency_contact[:relationship_type_id]).to eq(@emergency_contacts[index].relationship_type)
        expect(emergency_contact[:first_name]).to eq(@emergency_contacts[index].first_name)
        expect(emergency_contact[:last_name]).to eq(@emergency_contacts[index].last_name)
        expect(emergency_contact[:contact_type_id]).to eq(@emergency_contacts[index].contact_type)
        expect(emergency_contact[:contact]).to eq(@emergency_contacts[index].contact)
        expect(emergency_contact[:person_id]).to eq(@emergency_contacts[index].person)
      end
    end

  end

  describe "Emergency Contacts API Show" do

    it "returns http not authorized when not signed in" do
      emergency_contact_params = {
                                  relationship_type_id: relationship_type.id,
                                  first_name: "Test",
                                  last_name: "McTesterson",
                                  contact_type_id: contact_type.id,
                                  contact: "test@mctesterson.com"
                                }
      emergency_contact_json = emergency_contact_params.to_json

      sign_out login_user
      get "/api/v1/people/#{person.id}/emergency_contacts/#{emergency_contact.id}", params: emergency_contact_json, headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      emergency_contact_params = {
                                  relationship_type_id: relationship_type.id,
                                  first_name: "Test",
                                  last_name: "McTesterson",
                                  contact_type_id: contact_type.id,
                                  contact: "test@mctesterson.com"
                                }
      emergency_contact_json = emergency_contact_params.to_json

      get "/api/v1/people/#{person.id}/emergency_contacts/#{emergency_contact.id}", params: emergency_contact_json, headers: @headers
      expect(response).to have_http_status(200)
    end

    it "returns the details of the specified emergency contact" do
      emergency_contact_params = {
                                  relationship_type_id: relationship_type.id,
                                  first_name: "Test",
                                  last_name: "McTesterson",
                                  contact_type_id: contact_type.id,
                                  contact: "test@mctesterson.com"
                                }
      emergency_contact_json = emergency_contact_params.to_json

      get "/api/v1/people/#{person.id}/emergency_contacts/#{emergency_contact.id}", params: emergency_contact_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:emergency_contact][:id]).to eq(emergency_contact.id)
      expect(u[:emergency_contact][:relationship_type_id]).to eq(emergency_contact.relationship_type_id)
      expect(u[:emergency_contact][:first_name]).to eq(emergency_contact.first_name)
      expect(u[:emergency_contact][:last_name]).to eq(emergency_contact.last_name)
      expect(u[:emergency_contact][:contact_type_id]).to eq(emergency_contact.contact_type_id)
      expect(u[:emergency_contact][:contact]).to eq(emergency_contact.contact)
      expect(u[:emergency_contact][:person_id]).to eq(emergency_contact.person_id)
    end

  end

  describe "Emergency Contacts API Create" do

    it "returns http not authorized when not signed in" do
      emergency_contact_params = {
                                  relationship_type_id: relationship_type.id,
                                  first_name: "Test",
                                  last_name: "McTesterson",
                                  contact_type_id: contact_type.id,
                                  contact: "test@mctesterson.com"
                                }
      emergency_contact_json = emergency_contact_params.to_json

      sign_out login_user
      post "/api/v1/people/#{person.id}/emergency_contacts", params: emergency_contact_json, headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      emergency_contact_params = {
                                  relationship_type_id: relationship_type.id,
                                  first_name: "Test",
                                  last_name: "McTesterson",
                                  contact_type_id: contact_type.id,
                                  contact: "test@mctesterson.com"
                                }
      emergency_contact_json = emergency_contact_params.to_json

      post "/api/v1/people/#{person.id}/emergency_contacts/", params: emergency_contact_json, headers: @headers
      expect(response).to have_http_status(200)
    end

    it "is successful with valid parameters" do
      emergency_contact_params = {
                                  relationship_type_id: relationship_type.id,
                                  first_name: "Test",
                                  last_name: "McTesterson",
                                  contact_type_id: contact_type.id,
                                  contact: "test@mctesterson.com"
                                }
      emergency_contact_json = emergency_contact_params.to_json

      post "/api/v1/people/#{person.id}/emergency_contacts", params: emergency_contact_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:emergency_contact][:relationship_type_id]).to eq(emergency_contact_params[:relationship_type_id])
      expect(u[:emergency_contact][:first_name]).to eq(emergency_contact_params[:first_name])
      expect(u[:emergency_contact][:last_name]).to eq(emergency_contact_params[:last_name])
      expect(u[:emergency_contact][:contact_type_id]).to eq(emergency_contact_params[:contact_type_id])
      expect(u[:emergency_contact][:contact]).to eq(emergency_contact_params[:contact])
    end

    it "is not successful without a first name" do
      emergency_contact_params = {
                                  relationship_type_id: relationship_type.id,
                                  first_name: nil,
                                  last_name: "McTesterson",
                                  contact_type_id: contact_type.id,
                                  contact: "test@mctesterson.com"
                                }
      emergency_contact_json = emergency_contact_params.to_json

      post "/api/v1/people/#{person.id}/emergency_contacts", params: emergency_contact_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:first_name]).to eq(["can't be blank"])
    end

    it "is not successful without a last name" do
      emergency_contact_params = {
                                  relationship_type_id: relationship_type.id,
                                  first_name: "Test",
                                  last_name: nil,
                                  contact_type_id: contact_type.id,
                                  contact: "test@mctesterson.com"
                                }
      emergency_contact_json = emergency_contact_params.to_json

      post "/api/v1/people/#{person.id}/emergency_contacts", params: emergency_contact_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:last_name]).to eq(["can't be blank"])
    end

    it "is not successful without a contact" do
      emergency_contact_params = {
                                  relationship_type_id: relationship_type.id,
                                  first_name: "Test",
                                  last_name: "McTesterson",
                                  contact_type_id: contact_type.id,
                                  contact: nil,
                                }
      emergency_contact_json = emergency_contact_params.to_json

      post "/api/v1/people/#{person.id}/emergency_contacts", params: emergency_contact_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:contact]).to eq(["can't be blank"])
    end

    it "is not successful without a contact type id" do
      emergency_contact_params = {
                                  relationship_type_id: relationship_type.id,
                                  first_name: "Test",
                                  last_name: "McTesterson",
                                  contact_type_id: nil,
                                  contact: "test@mctesterson.com",
                                }
      emergency_contact_json = emergency_contact_params.to_json

      post "/api/v1/people/#{person.id}/emergency_contacts", params: emergency_contact_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:contact_type]).to eq(["must exist"])
    end

    it "is not successful without a relationship type id" do
      emergency_contact_params = {
                                  relationship_type_id: nil,
                                  first_name: "Test",
                                  last_name: "McTesterson",
                                  contact_type_id: nil,
                                  contact: "test@mctesterson.com",
                                }
      emergency_contact_json = emergency_contact_params.to_json

      post "/api/v1/people/#{person.id}/emergency_contacts", params: emergency_contact_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:relationship_type]).to eq(["must exist"])
    end

  end

  describe "Emergency Contacts API Update" do

    it "returns http not authorized when not signed in" do
      emergency_contact_params = {
                                  relationship_type_id: relationship_type.id,
                                  first_name: "Test",
                                  last_name: "McTesterson",
                                  contact_type_id: contact_type.id,
                                  contact: "test@mctesterson.com",
                                }
      emergency_contact_json = emergency_contact_params.to_json

      sign_out login_user
      patch "/api/v1/people/#{person.id}/emergency_contacts/#{emergency_contact.id}", params: emergency_contact_json, headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      emergency_contact_params = {
                                  relationship_type_id: relationship_type.id,
                                  first_name: "Test",
                                  last_name: "McTesterson",
                                  contact_type_id: contact_type.id,
                                  contact: "test@mctesterson.com",
                                }
      emergency_contact_json = emergency_contact_params.to_json

      patch "/api/v1/people/#{person.id}/emergency_contacts/#{emergency_contact.id}", params: emergency_contact_json, headers: @headers
      expect(response).to have_http_status(200)
    end

    it "is successful with valid parameters" do
      emergency_contact_params = {
                                  relationship_type_id: relationship_type.id,
                                  first_name: "Test",
                                  last_name: "McTesterson",
                                  contact_type_id: contact_type.id,
                                  contact: "test@mctesterson.com"
                                }
      emergency_contact_json = emergency_contact_params.to_json

      patch "/api/v1/people/#{person.id}/emergency_contacts/#{emergency_contact.id}", params: emergency_contact_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:emergency_contact][:relationship_type_id]).to eq(emergency_contact_params[:relationship_type_id])
      expect(u[:emergency_contact][:first_name]).to eq(emergency_contact_params[:first_name])
      expect(u[:emergency_contact][:last_name]).to eq(emergency_contact_params[:last_name])
      expect(u[:emergency_contact][:contact_type_id]).to eq(emergency_contact_params[:contact_type_id])
      expect(u[:emergency_contact][:contact]).to eq(emergency_contact_params[:contact])
    end

    it "is not successful without a first name" do
      emergency_contact_params = {
                                  relationship_type_id: relationship_type.id,
                                  first_name: nil,
                                  last_name: "McTesterson",
                                  contact_type_id: contact_type.id,
                                  contact: "test@mctesterson.com"
                                }
      emergency_contact_json = emergency_contact_params.to_json

      patch "/api/v1/people/#{person.id}/emergency_contacts/#{emergency_contact.id}", params: emergency_contact_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:first_name]).to eq(["can't be blank"])
    end

    it "is not successful without a last name" do
      emergency_contact_params = {
                                  relationship_type_id: relationship_type.id,
                                  first_name: "Test",
                                  last_name: nil,
                                  contact_type_id: contact_type.id,
                                  contact: "test@mctesterson.com"
                                }
      emergency_contact_json = emergency_contact_params.to_json

      patch "/api/v1/people/#{person.id}/emergency_contacts/#{emergency_contact.id}", params: emergency_contact_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:last_name]).to eq(["can't be blank"])
    end

    it "is not successful without a contact" do
      emergency_contact_params = {
                                  relationship_type_id: relationship_type.id,
                                  first_name: "Test",
                                  last_name: "McTesterson",
                                  contact_type_id: contact_type.id,
                                  contact: nil
                                }
      emergency_contact_json = emergency_contact_params.to_json

      patch "/api/v1/people/#{person.id}/emergency_contacts/#{emergency_contact.id}", params: emergency_contact_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:contact]).to eq(["can't be blank"])
    end

    it "is not successful without contact type id" do
      emergency_contact_params = {
                                  relationship_type_id: relationship_type.id,
                                  first_name: "Test",
                                  last_name: "McTesterson",
                                  contact_type_id: nil,
                                  contact: "test@mctesterson.com"
                                }
      emergency_contact_json = emergency_contact_params.to_json

      patch "/api/v1/people/#{person.id}/emergency_contacts/#{emergency_contact.id}", params: emergency_contact_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:contact_type]).to eq(["must exist"])
    end

    it "is not successful without a relationship type id" do
      emergency_contact_params = {
                                  relationship_type_id: nil,
                                  first_name: "Test",
                                  last_name: "McTesterson",
                                  contact_type_id: contact_type.id,
                                  contact: "test@mctesterson.com"
                                }
      emergency_contact_json = emergency_contact_params.to_json

      patch "/api/v1/people/#{person.id}/emergency_contacts/#{emergency_contact.id}", params: emergency_contact_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:relationship_type]).to eq(["must exist"])
    end

  end

  describe "Emergency Contacts API Destroy" do

    it "returns http not authorized when not signed in" do
      sign_out login_user
      delete "/api/v1/people/#{person.id}/emergency_contacts/#{emergency_contact.id}", headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      delete "/api/v1/people/#{person.id}/emergency_contacts/#{emergency_contact.id}", headers: @headers
      expect(response).to have_http_status(200)
    end

    it "returns the list of employee without the deleted employee" do
      delete "/api/v1/people/#{person.id}/emergency_contacts/#{emergency_contact.id}", headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:emergency_contacts].any? { |value| emergency_contact }).to eq(false)
    end

  end

end
