require 'rails_helper'

RSpec.describe Api::V1::BenefitsController, type: :request do

  let(:login_user)    { create(:user) }
  let(:person)        { create(:person) }
  let(:employee)      { create(:employee, person: person) }
  let(:benefit)       { create(:benefit, employee: employee) }
  let(:benefit_type1) { create(:benefit_type, name: "Health Insurance")}
  let(:benefit_type2) { create(:benefit_type, name: "Family/Medical Leave")}

  before(:each) do
    @headers = { 'ACCEPT': 'application/json',  'CONTENT-TYPE': 'application/json' }
    sign_in login_user
  end

  describe "Benefits API Index " do

    it 'returns http not authorized when not signed in' do
      sign_out login_user
      get "/api/v1/employees/#{employee.id}/benefits", headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      get "/api/v1/employees/#{employee.id}/benefits", headers: @headers
      expect(response).to have_http_status(200)
    end

    it "returns the list of benefits" do
      @benefits = []
      @benefits << build(:benefit, employee: employee, benefit_type: benefit_type1)
      @benefits << build(:benefit, employee: employee, benefit_type: benefit_type2)
      @benefits.sort!

      get "/api/v1/employees/#{employee.id}/benefits", headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      u[:benefits].each_with_index do |benefit, index|
        expect(benefit[:id]).to eq(@benefits[index].id)
        expect(benefit[:employee_id]).to eq(@benefits[index].employee_id)
        expect(benefit[:benefit_type_id]).to eq(@benefits[index].benefit_type_id)
        expect(benefit[:eligible_at]).to eq(@benefits[index].eligible_at)
        expect(benefit[:notified_at]).to eq(@benefits[index].notified_at)
        expect(benefit[:eligile_at]).to eq(@benefits[index].eligile_at)
        expect(benefit[:updated_by]).to eq(@benefits[index].updated_by)
        expect(benefit[:notes]).to eq(@benefits[index].notes)
      end
    end

  end

  describe "Benefits API Show" do

    it "returns http not authorized when not signed in" do
      benefit_params      = {
                              employee_id: employee.id,
                              benefit_type_id: benefit_type1.id,
                              eligible_at: Date.today,
                              notified_at: Date.today,
                              updated_by: employee.id,
                              notes: Faker::Lorem.paragraph
                            }
      benefit_params_json = benefit_params.to_json

      sign_out login_user
      get "/api/v1/employees/#{employee.id}/benefits/#{benefit.id}", params: benefit_params_json, headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      benefit_params      = {
                              employee_id: employee.id,
                              benefit_type_id: benefit_type1.id,
                              eligible_at: Date.today,
                              notified_at: Date.today,
                              updated_by: employee.id,
                              notes: Faker::Lorem.paragraph
                            }
      benefit_params_json = benefit_params.to_json

      get "/api/v1/employees/#{employee.id}/benefits/#{benefit.id}", params: benefit_params_json, headers: @headers
      expect(response).to have_http_status(200)
    end

    it "returns the details of the specified benefit" do
      benefit_params      = {
                              employee_id: employee.id,
                              benefit_type_id: benefit_type1.id,
                              eligible_at: Date.today,
                              notified_at: Date.today,
                              updated_by: employee.id,
                              notes: Faker::Lorem.paragraph
                            }
      benefit_params_json = benefit_params.to_json

      get "/api/v1/employees/#{employee.id}/benefits/#{benefit.id}", params: benefit_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:benefit][:id]).to eq(benefit.id)
      expect(u[:benefit][:employee_id]).to eq(benefit.employee_id)
      expect(u[:benefit][:benefit_type_id]).to eq(benefit.benefit_type_id)
      expect(u[:benefit][:eligible_at]).to eq(benefit.eligible_at.strftime("%Y-%m-%d"))
      expect(u[:benefit][:notified_at]).to eq(benefit.notified_at.strftime("%Y-%m-%d"))
      expect(u[:benefit][:updated_by]).to eq(benefit.updated_by)
      expect(u[:benefit][:notes]).to eq(benefit.notes)
    end

  end

  describe "Benefits API Create" do

    it "returns http not authorized when not signed in" do
      benefit_params      = {
                              employee_id: employee.id,
                              benefit_type_id: benefit_type1.id,
                              eligible_at: Date.today,
                              notified_at: Date.today,
                              updated_by: employee.id,
                              notes: Faker::Lorem.paragraph
                            }
      benefit_params_json = benefit_params.to_json

      sign_out login_user
      post "/api/v1/employees/#{employee.id}/benefits", params: benefit_params_json, headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      benefit_params      = {
                              employee_id: employee.id,
                              benefit_type_id: benefit_type1.id,
                              eligible_at: Date.today,
                              notified_at: Date.today,
                              updated_by: employee.id,
                              notes: Faker::Lorem.paragraph
                            }
      benefit_params_json = benefit_params.to_json

      post "/api/v1/employees/#{employee.id}/benefits/", params: benefit_params_json, headers: @headers
      expect(response).to have_http_status(200)
    end

    it "is successful with valid parameters" do
      benefit_params      = {
                              employee_id: employee.id,
                              benefit_type_id: benefit_type1.id,
                              eligible_at: Date.today,
                              notified_at: Date.today,
                              updated_by: employee.id,
                              notes: Faker::Lorem.paragraph
                            }
      benefit_params_json = benefit_params.to_json

      post "/api/v1/employees/#{employee.id}/benefits", params: benefit_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:benefit][:employee_id]).to eq(benefit_params[:employee_id])
      expect(u[:benefit][:benefit_type_id]).to eq(benefit_params[:benefit_type_id])
      expect(u[:benefit][:eligible_at]).to eq(benefit_params[:eligible_at].strftime("%Y-%m-%d"))
      expect(u[:benefit][:notified_at]).to eq(benefit_params[:notified_at].strftime("%Y-%m-%d"))
      expect(u[:benefit][:updated_by]).to eq(benefit_params[:updated_by])
      expect(u[:benefit][:notes]).to eq(benefit_params[:notes])
    end

  end

  describe "Benefits API Update" do

    it "returns http not authorized when not signed in" do
      benefit_params      = {
                              employee_id: employee.id,
                              benefit_type_id: benefit_type1.id,
                              eligible_at: Date.today,
                              notified_at: Date.today,
                              updated_by: employee.id,
                              notes: Faker::Lorem.paragraph
                            }
      benefit_params_json = benefit_params.to_json

      sign_out login_user
      patch "/api/v1/employees/#{employee.id}/benefits/#{benefit.id}", params: benefit_params_json, headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      benefit_params      = {
                              employee_id: employee.id,
                              benefit_type_id: benefit_type1.id,
                              eligible_at: Date.today,
                              notified_at: Date.today,
                              updated_by: employee.id,
                              notes: Faker::Lorem.paragraph
                            }
      benefit_params_json = benefit_params.to_json

      patch "/api/v1/employees/#{employee.id}/benefits/#{benefit.id}", params: benefit_params_json, headers: @headers
      expect(response).to have_http_status(200)
    end

    it "is successful with valid parameters" do
      benefit_params      = {
                              employee_id: employee.id,
                              benefit_type_id: benefit_type1.id,
                              eligible_at: Date.today,
                              notified_at: Date.today,
                              updated_by: employee.id,
                              notes: Faker::Lorem.paragraph
                            }
      benefit_params_json = benefit_params.to_json

      patch "/api/v1/employees/#{employee.id}/benefits/#{benefit.id}", params: benefit_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:benefit][:employee_id]).to eq(benefit_params[:employee_id])
      expect(u[:benefit][:benefit_type_id]).to eq(benefit_params[:benefit_type_id])
      expect(u[:benefit][:eligible_at]).to eq(benefit_params[:eligible_at].strftime("%Y-%m-%d"))
      expect(u[:benefit][:notified_at]).to eq(benefit_params[:notified_at].strftime("%Y-%m-%d"))

      expect(u[:benefit][:updated_by]).to eq(benefit_params[:updated_by])
      expect(u[:benefit][:notes]).to eq(benefit_params[:notes])
    end

  end

  describe "Benefits API Destroy" do

    it "returns http not authorized when not signed in" do
      sign_out login_user
      delete "/api/v1/employees/#{employee.id}/benefits/#{benefit.id}", headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      delete "/api/v1/employees/#{employee.id}/benefits/#{benefit.id}", headers: @headers
      expect(response).to have_http_status(200)
    end

    it "returns the list of benefits without the deleted benefit" do
      delete "/api/v1/employees/#{employee.id}/benefits/#{benefit.id}", headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:benefits].any? { |value| benefit }).to eq(false)
    end

  end

end

