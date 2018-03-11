require 'rails_helper'

RSpec.describe Api::V1::PeopleController, type: :request do

  let(:login_user)  { create(:user) }
  let(:person)     { create(:person) }

  before(:each) do
    @headers = { 'ACCEPT': 'application/json',  'CONTENT-TYPE': 'application/json' }
    sign_in login_user
  end

  describe "People API Index " do

    it 'returns http not authorized when not signed in' do
      sign_out login_user
      get "/api/v1/people", headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      get "/api/v1/people", headers: @headers
      expect(response).to have_http_status(200)
    end

    it "returns the list of person" do
      @people = []
      @people << build(:person)
      @people << build(:person)
      @people.sort!

      get "/api/v1/people", headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      u[:people].each_with_index do |person, index|
        expect(person[:id]).to eq(@people[index].id)
        expect(person[:first_name]).to eq(@people[index].first_name)
        expect(person[:middle_name]).to eq(@people[index].middle_name)
        expect(person[:last_name]).to eq(@people[index].last_name)
        expect(person[:prefix]).to eq(@people[index].prefix)
        expect(person[:suffix]).to eq(@people[index].suffix)
        expect(person[:date_of_birth]).to eq(@people[index].date_of_birth)
      end
    end

  end

  describe "People API Show" do

    it "returns http not authorized when not signed in" do
      person_params      = { first_name: "Kelly", last_name: "McDaniel", date_of_birth: '1968-01-12' }
      person_params_json = person_params.to_json

      sign_out login_user
      get "/api/v1/people/#{person.id}", params: person_params_json, headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      person_params      = { first_name: "Kelly", last_name: "McDaniel", date_of_birth: '1968-01-12' }
      person_params_json = person_params.to_json

      get "/api/v1/people/#{person.id}", params: person_params_json, headers: @headers
      expect(response).to have_http_status(200)
    end

    it "returns the details of the specified person" do
      person_params      = { first_name: "Kelly", last_name: "McDaniel", date_of_birth: '1968-01-12' }
      person_params_json = person_params.to_json

      get "/api/v1/people/#{person.id}", params: person_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:person][:id]).to eq(person.id)
      expect(u[:person][:first_name]).to eq(person.first_name)
      expect(u[:person][:middle_name]).to eq(person.middle_name)
      expect(u[:person][:last_name]).to eq(person.last_name)
      expect(u[:person][:prefix]).to eq(person.prefix)
      expect(u[:person][:suffix]).to eq(person.suffix)
      expect(u[:person][:date_of_birth]).to eq(person.date_of_birth.strftime("%Y-%m-%d"))
    end

  end

  describe "People API Create" do

    it "returns http not authorized when not signed in" do
      person_params      = { first_name: "Kelly", last_name: "McDaniel", date_of_birth: '1968-01-12' }
      person_params_json = person_params.to_json

      sign_out login_user
      post "/api/v1/people", params: person_params_json, headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      person_params      = { first_name: "Kelly", last_name: "McDaniel", date_of_birth: '1968-01-12' }
      person_params_json = person_params.to_json

      post "/api/v1/people/", params: person_params_json, headers: @headers
      expect(response).to have_http_status(200)
    end

    it "is successful with valid parameters" do
      person_params      = { first_name: "Kelly", last_name: "McDaniel", date_of_birth: '1968-01-12' }
      person_params_json = person_params.to_json

      post "/api/v1/people", params: person_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:person][:first_name]).to eq(person_params[:first_name])
      expect(u[:person][:last_name]).to eq(person_params[:last_name])
      expect(u[:person][:date_of_birth]).to eq(person_params[:date_of_birth])
    end

    it "is not successful without a first name" do
      person_params      = { first_name: nil, last_name: "McDaniel", date_of_birth: '1968-01-12' }
      person_params_json = person_params.to_json

      post "/api/v1/people", params: person_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:first_name]).to eq(["can't be blank"])
    end

    it "is not successful without a last name" do
      person_params      = { first_name: "Kelly", last_name: nil, date_of_birth: '1968-01-12' }
      person_params_json = person_params.to_json

      post "/api/v1/people", params: person_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:last_name]).to eq(["can't be blank"])
    end

    it "is not successful without a date of birth" do
      person_params      = { first_name: "Kelly", last_name: "McDaniel", date_of_birth: nil }
      person_params_json = person_params.to_json

      post "/api/v1/people", params: person_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:date_of_birth]).to eq(["can't be blank"])
    end

  end

  describe "People API Update" do

    it "returns http not authorized when not signed in" do
      person_params      = { first_name: "Kelly", last_name: "McDaniel", date_of_birth: '1968-01-12' }
      person_params_json = person_params.to_json

      sign_out login_user
      patch "/api/v1/people/#{person.id}", params: person_params_json, headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      person_params      = { first_name: "Kelly", last_name: "McDaniel", date_of_birth: '1968-01-12' }
      person_params_json = person_params.to_json

      patch "/api/v1/people/#{person.id}", params: person_params_json, headers: @headers
      expect(response).to have_http_status(200)
    end

    it "is successful with valid parameters" do
      person_params      = { first_name: "Kelly", last_name: "McDaniel", date_of_birth: '1968-01-12' }
      person_params_json = person_params.to_json

      patch "/api/v1/people/#{person.id}", params: person_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:person][:first_name]).to eq(person_params[:first_name])
      expect(u[:person][:last_name]).to eq(person_params[:last_name])
      expect(u[:person][:date_of_birth]).to eq(person_params[:date_of_birth])
    end

    it "is not successful without a first name" do
      person_params      = { first_name: nil, last_name: "McDaniel", date_of_birth: '1968-01-12' }
      person_params_json = person_params.to_json

      patch "/api/v1/people/#{person.id}", params: person_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:first_name]).to eq(["can't be blank"])
    end

    it "is not successful without a last name" do
      person_params      = { first_name: "Kelly", last_name: nil, date_of_birth: '1968-01-12' }
      person_params_json = person_params.to_json

      patch "/api/v1/people/#{person.id}", params: person_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:last_name]).to eq(["can't be blank"])
    end

    it "is not successful without a date of birth" do
      person_params      = { first_name: "Kelly", last_name: "McDaniel", date_of_birth: nil }
      person_params_json = person_params.to_json

      patch "/api/v1/people/#{person.id}", params: person_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:date_of_birth]).to eq(["can't be blank"])
    end

  end

  describe "People API Destroy" do

    it "returns http not authorized when not signed in" do
      sign_out login_user
      delete "/api/v1/people/#{person.id}", headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      delete "/api/v1/people/#{person.id}", headers: @headers
      expect(response).to have_http_status(200)
    end

    it "returns the list of person without the deleted person" do
      delete "/api/v1/people/#{person.id}", headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:people].any? { |value| person }).to eq(false)
    end

  end

end
