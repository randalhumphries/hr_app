require 'rails_helper'

RSpec.describe Api::V1::Admin::UsersController, type: :request do

  let(:company)       { create(:company) }
  let(:other_company) { create(:company) }
  let(:admin)         { create(:user, :admin, company: company) }
  let(:user)          { create(:user, company: company) }
  let(:other_user)    { create(:user, company: other_company) }

  before(:each) do
    @headers = { 'ACCEPT': 'application/json',  'CONTENT-TYPE': 'application/json' }
    sign_in admin
  end

  describe "Users API Index" do

    it 'returns http not authorized when not signed in' do
      sign_out admin
      get "/api/v1/admin/users", headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http not authorized when signed in and not an admin" do
      sign_out admin
      sign_in user
      get "/api/v1/admin/users", headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in and an admin" do
      get "/api/v1/admin/users", headers: @headers
      expect(response).to have_http_status(200)
    end

    it 'returns the list of current users' do
      @users = []
      @users << create(:user, company: company)
      @users << create(:user, company: company)
      @users << create(:user, company: company)
      @users << admin
      @users.sort!

      get "/api/v1/admin/users", headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:users].length).to eq(@users.length)
      u[:users].each_with_index do |user, index|
        expect(user[:id]).to eq(@users[index].id)
        expect(user[:email]).to eq(@users[index].email)
        expect(user[:admin]).to eq(@users[index].admin)
        expect(user[:active]).to eq(@users[index].active)
        expect(user[:company_id]).to eq(@users[index].company_id)
      end
    end

  end

  describe "Users API Show" do

    it 'returns http not authorized when not signed in' do
      sign_out admin
      get "/api/v1/admin/users/#{user.id}", headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http not authorized when signed in and not an admin" do
      sign_out admin
      sign_in user
      get "/api/v1/admin/users/#{user.id}", headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in and an admin" do
      get "/api/v1/admin/users/#{user.id}", headers: @headers
      expect(response).to have_http_status(200)
    end

    it "returns the details of the specified user" do
      get "/api/v1/admin/users/#{user.id}", headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:user][:email]).to eq(user.email)
      expect(u[:user][:admin]).to eq(user.admin)
      expect(u[:user][:active]).to eq(user.active)
      expect(u[:user][:company_id]).to eq(user.company_id)
    end

  end

  describe "Users API Update" do

    it 'returns http not authorized when not signed in' do
      user_params      = { id: user.id, email: Faker::Internet.email }
      user_params_json = user_params.to_json

      sign_out admin
      patch "/api/v1/admin/users/#{user.id}", params: user_params_json, headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http not authorized when signed in and not an admin" do
      user_params      = { id: user.id, email: Faker::Internet.email }
      user_params_json = user_params.to_json

      sign_out admin
      sign_in user
      patch "/api/v1/admin/users/#{user.id}", params: user_params_json, headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in and an admin" do
      user_params      = { id: user.id, email: Faker::Internet.email }
      user_params_json = user_params.to_json

      patch "/api/v1/admin/users/#{user.id}", params: user_params_json, headers: @headers
      expect(response).to have_http_status(200)
    end

    it "is successful with valid parameters" do
      user_params      = { id: user.id, email: Faker::Internet.email }
      user_params_json = user_params.to_json

      patch "/api/v1/admin/users/#{user.id}", params: user_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:user][:email]).not_to eq(user.email)
      expect(u[:user][:email]).to eq(user_params[:email])
    end

  end

  describe "Users API Create" do

    it 'returns http not authorized when not signed in' do
      password         = Faker::Internet.password
      user_params      = {
                          email: Faker::Internet.email,
                          password: password,
                          password_confirmation: password
                        }
      user_params_json = user_params.to_json

      sign_out admin
      post "/api/v1/admin/users/", params: user_params_json, headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http not authorized when signed in and not an admin" do
      password         = Faker::Internet.password
      user_params      = {
                          email: Faker::Internet.email,
                          password: password,
                          password_confirmation: password
                        }
      user_params_json = user_params.to_json

      sign_out admin
      sign_in user
      post "/api/v1/admin/users/", params: user_params_json, headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in and an admin" do
      password         = Faker::Internet.password
      user_params      = {
                          email: Faker::Internet.email,
                          password: password,
                          password_confirmation: password
                        }
      user_params_json = user_params.to_json

      post "/api/v1/admin/users/", params: user_params_json, headers: @headers
      expect(response).to have_http_status(200)
    end

    it "is successful with valid parameters" do
      password         = Faker::Internet.password
      user_params      = {
                          email: Faker::Internet.email,
                          password: password,
                          password_confirmation: password
                        }
      user_params_json = user_params.to_json

      post "/api/v1/admin/users/", params: user_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:user][:email]).to eq(user_params[:email])
    end

    it 'is not successful without an email' do
      password         = Faker::Internet.password
      user_params      = {
                          email: nil,
                          password: password,
                          password_confirmation: password
                        }
      user_params_json = user_params.to_json

      post "/api/v1/admin/users/", params: user_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:email]).to eq(["can't be blank"])
    end

    it 'returns errors without a password' do
      user_params      = {
                          email: Faker::Internet.email,
                          password: nil,
                          password_confirmation: nil
                        }
      user_params_json = user_params.to_json

      post "/api/v1/admin/users/", params: user_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:password]).to eq(["can't be blank"])
    end

  end

end
