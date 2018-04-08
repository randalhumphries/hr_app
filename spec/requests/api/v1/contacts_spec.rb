require 'rails_helper'

RSpec.describe Api::V1::ContactsController, type: :request do

  let(:random_name1)   { generate_random_string(16) }
  let(:random_name2)   { generate_random_string(16) }
  let(:random_name3)   { generate_random_string(16) }
  let(:login_user)     { create(:user) }
  let(:person)         { create(:person) }
  let(:contact_type1)  { create(:contact_type, name: random_name1) }
  let(:contact_type2)  { create(:contact_type, name: random_name2) }
  let(:contact_type3)  { create(:contact_type, name: random_name3) }
  let(:contact)        { create(:contact, person: person, contact_type: contact_type1) }

  before(:each) do
    @headers = { 'ACCEPT': 'application/json',  'CONTENT-TYPE': 'application/json' }
    sign_in login_user
  end

  describe "Contacts API Index " do

    it 'returns http not authorized when not signed in' do
      sign_out login_user
      get "/api/v1/people/#{person.id}/contacts", headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      get "/api/v1/people/#{person.id}/contacts", headers: @headers
      expect(response).to have_http_status(200)
    end

    it "returns the list of contact" do
      @contacts = []
      @contacts << build(:contact, person: person, contact_type: contact_type2)
      @contacts << build(:contact,  person: person, contact_type: contact_type3)
      @contacts.sort!

      get "/api/v1/people/#{person.id}/contacts", headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      u[:contacts].each_with_index do |contact, index|
        expect(contact[:id]).to eq(@contacts[index].id)
        expect(contact[:person_id]).to eq(@contacts[index].person_id)
        expect(contact[:contact_type_id]).to eq(@contacts[index].contact_type_id)
        expect(contact[:contact]).to eq(@contacts[index].contact)
      end
    end

  end

  describe "Contacts API Show" do

    it "returns http not authorized when not signed in" do
      contact_params      = { person_id: person.id, contact_type_id: contact_type1.id, contact: Faker::Internet.email }
      contact_params_json = contact_params.to_json

      sign_out login_user
      get "/api/v1/people/#{person.id}/contacts/#{contact.id}", params: contact_params_json, headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      contact_params      = { person_id: person.id, contact_type_id: contact_type1.id, contact: Faker::Internet.email }
      contact_params_json = contact_params.to_json

      get "/api/v1/people/#{person.id}/contacts/#{contact.id}", params: contact_params_json, headers: @headers
      expect(response).to have_http_status(200)
    end

    it "returns the details of the specified contact" do
      contact_params      = { person_id: person.id, contact_type_id: contact_type1.id, contact: Faker::Internet.email }
      contact_params_json = contact_params.to_json

      get "/api/v1/people/#{person.id}/contacts/#{contact.id}", params: contact_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:contact][:id]).to eq(contact.id)
      expect(u[:contact][:person_id]).to eq(contact.person_id)
      expect(u[:contact][:contact_type_id]).to eq(contact.contact_type_id)
      expect(u[:contact][:contact]).to eq(contact.contact)
    end

  end

  describe "Contacts API Create" do

    it "returns http not authorized when not signed in" do
      contact_params      = { person_id: person.id, contact_type_id: contact_type1.id, contact: Faker::Internet.email }
      contact_params_json = contact_params.to_json

      sign_out login_user
      post "/api/v1/people/#{person.id}/contacts", params: contact_params_json, headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      contact_params      = { person_id: person.id, contact_type_id: contact_type1.id, contact: Faker::Internet.email }
      contact_params_json = contact_params.to_json

      post "/api/v1/people/#{person.id}/contacts/", params: contact_params_json, headers: @headers
      expect(response).to have_http_status(200)
    end

    it "is successful with valid parameters" do
      contact_params      = { person_id: person.id, contact_type_id: contact_type1.id, contact: Faker::Internet.email }
      contact_params_json = contact_params.to_json

      post "/api/v1/people/#{person.id}/contacts", params: contact_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:contact][:person_id]).to eq(contact_params[:person_id])
      expect(u[:contact][:contact_type_id]).to eq(contact_params[:contact_type_id])
      expect(u[:contact][:contact]).to eq(contact_params[:contact])
    end

    it "is not successful without a contact" do
      contact_params      = { person_id: person.id, contact_type_id: contact_type1.id, contact: nil }
      contact_params_json = contact_params.to_json

      post "/api/v1/people/#{person.id}/contacts", params: contact_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:contact]).to eq(["can't be blank"])
    end

    it "is not successful without a contact type id" do
      contact_params      = { person_id: person.id, contact_type_id: nil, contact: Faker::Internet.email }
      contact_params_json = contact_params.to_json

      post "/api/v1/people/#{person.id}/contacts", params: contact_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:contact_type]).to eq(["must exist"])
    end

  end

  describe "Contacts API Update" do

    it "returns http not authorized when not signed in" do
      contact_params      = { person_id: person.id, contact_type_id: contact_type1.id, contact: Faker::Internet.email }
      contact_params_json = contact_params.to_json

      sign_out login_user
      patch "/api/v1/people/#{person.id}/contacts/#{contact.id}", params: contact_params_json, headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      contact_params      = { person_id: person.id, contact_type_id: contact_type1.id, contact: Faker::Internet.email }
      contact_params_json = contact_params.to_json

      patch "/api/v1/people/#{person.id}/contacts/#{contact.id}", params: contact_params_json, headers: @headers
      expect(response).to have_http_status(200)
    end

    it "is successful with valid parameters" do
      contact_params      = { person_id: person.id, contact_type_id: contact_type1.id, contact: Faker::Internet.email }
      contact_params_json = contact_params.to_json

      patch "/api/v1/people/#{person.id}/contacts/#{contact.id}", params: contact_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:contact][:person_id]).to eq(contact_params[:person_id])
      expect(u[:contact][:contact_type_id]).to eq(contact_params[:contact_type_id])
      expect(u[:contact][:contact]).to eq(contact_params[:contact])
    end

    it "is not successful without a contact" do
      contact_params      = { person_id: person.id, contact_type_id: contact_type1.id, contact: nil }
      contact_params_json = contact_params.to_json

      patch "/api/v1/people/#{person.id}/contacts/#{contact.id}", params: contact_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:contact]).to eq(["can't be blank"])
    end

    it "is not successful without a contact type id" do
      contact_params      = { person_id: person.id, contact_type_id: nil, contact: Faker::Internet.email }
      contact_params_json = contact_params.to_json

      patch "/api/v1/people/#{person.id}/contacts/#{contact.id}", params: contact_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:contact_type]).to eq(["must exist"])
    end

  end

  describe "Contacts API Destroy" do

    it "returns http not authorized when not signed in" do
      sign_out login_user
      delete "/api/v1/people/#{person.id}/contacts/#{contact.id}", headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      delete "/api/v1/people/#{person.id}/contacts/#{contact.id}", headers: @headers
      expect(response).to have_http_status(200)
    end

    it "returns the list of contact without the deleted contact" do
      delete "/api/v1/people/#{person.id}/contacts/#{contact.id}", headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:contacts].any? { |value| contact }).to eq(false)
    end

  end

end
