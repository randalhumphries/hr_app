require 'rails_helper'

RSpec.describe Api::V1::Admin::UsersController, type: :request do

  let(:company)    { create(:company) }
  let(:login_user) { create(:user, :admin, company: company) }

  before(:each) do
    @headers = { 'ACCEPT': 'application/json',  'CONTENT-TYPE': 'application/json' }
    sign_in login_user
  end

  describe "Users API Index" do

    it 'returns http not authorized when not signed in' do
      sign_out login_user
      get "/api/v1/admin/users", headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      get "/api/v1/admin/users", headers: @headers
      expect(response).to have_http_status(200)
    end

    it 'returns the list of current users' do

      @users = create_list(:user, 10)
      (@users << login_user).sort!

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
      sign_out login_user
      get "/api/v1/admin/users/#{login_user.id}", headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      get "/api/v1/admin/users/#{login_user.id}", headers: @headers
      expect(response).to have_http_status(200)
    end

    it "returns the details of the specified user" do
      get "/api/v1/admin/users/#{login_user.id}", headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:user][:email]).to eq(login_user.email)
      expect(u[:user][:admin]).to eq(login_user.admin)
      expect(u[:user][:active]).to eq(login_user.active)
      expect(u[:user][:company_id]).to eq(login_user.company_id)
    end

  end

  describe "Users API Update" do

    it 'returns http not authorized when not signed in' do
      user_params      = { id: login_user.id, email: Faker::Internet.email, company_id: company.id }
      user_params_json = user_params.to_json

      sign_out login_user
      patch "/api/v1/admin/users/#{login_user.id}", params: user_params_json, headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      user_params      = { id: login_user.id, email: Faker::Internet.email, company_id: company.id }
      user_params_json = user_params.to_json

      patch "/api/v1/admin/users/#{login_user.id}", params: user_params_json, headers: @headers
      expect(response).to have_http_status(200)
    end

    it "is successful with valid parameters" do
      user_params      = { id: login_user.id, email: Faker::Internet.email, company_id: company.id }
      user_params_json = user_params.to_json

      patch "/api/v1/admin/users/#{login_user.id}", params: user_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:user][:email]).not_to eq(login_user.email)
      expect(u[:user][:email]).to eq(user_params[:email])
    end

  end

  describe "Users API Create" do

    it 'returns http not authorized when not signed in' do
      password         = Faker::Internet.password
      user_params      = {
                          email: Faker::Internet.email,
                          password: password,
                          password_confirmation: password,
                          company_id: company.id
                        }
      user_params_json = user_params.to_json

      sign_out login_user
      post "/api/v1/admin/users/", params: user_params_json, headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      password         = Faker::Internet.password
      user_params      = {
                          email: Faker::Internet.email,
                          password: password,
                          password_confirmation: password,
                          company_id: company.id
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
                          password_confirmation: password,
                          company_id: company.id
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
                          password_confirmation: password,
                          company_id: company.id
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
                          password_confirmation: nil,
                          company_id: company.id
                        }
      user_params_json = user_params.to_json

      post "/api/v1/admin/users/", params: user_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:password]).to eq(["can't be blank"])
    end

    it 'is not successful without a company' do
      password         = Faker::Internet.password
      user_params      = {
                          email: Faker::Internet.email,
                          password: password,
                          password_confirmation: password,
                          company_id: nil
                        }
      user_params_json = user_params.to_json

      post "/api/v1/admin/users/", params: user_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:company]).to eq(["must exist"])
    end

  end

end
