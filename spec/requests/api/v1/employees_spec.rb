require 'rails_helper'

RSpec.describe Api::V1::EmployeesController, type: :request do

  let(:login_user)  { create(:user) }
  let(:person)      { create(:person) }
  let(:employee)    { create(:employee, person: person) }

  before(:each) do
    @headers = { 'ACCEPT': 'application/json',  'CONTENT-TYPE': 'application/json' }
    sign_in login_user
  end

  describe "Employees API Index " do

    it 'returns http not authorized when not signed in' do
      sign_out login_user
      get "/api/v1/employees", headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      get "/api/v1/employees", headers: @headers
      expect(response).to have_http_status(200)
    end

    it "returns the list of employee" do
      @employees = []
      @employees << build(:employee)
      @employees << build(:employee)
      @employees.sort!

      get "/api/v1/employees", headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      u[:employees].each_with_index do |employee, index|
        expect(employee[:id]).to eq(@employees[index].id)
        expect(employee[:active]).to eq(@employees[index].active)
        expect(employee[:temp_hire_at]).to eq(@employees[index].temp_hire_at)
        expect(employee[:full_time_hire_at]).to eq(@employees[index].full_time_hire_at)
        expect(employee[:person_id]).to eq(@employees[index].person_id)
      end
    end

  end

  describe "Employees API Show" do

    it "returns http not authorized when not signed in" do
      employee_params      = { active: true, temp_hire_at: "#{Date.today}", full_time_hire_at: nil, person_id: "#{person.id}" }
      employee_params_json = employee_params.to_json

      sign_out login_user
      get "/api/v1/employees/#{employee.id}", params: employee_params_json, headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      employee_params      = { active: true, temp_hire_at: "#{Date.today}", full_time_hire_at: nil, person_id: "#{person.id}" }
      employee_params_json = employee_params.to_json

      get "/api/v1/employees/#{employee.id}", params: employee_params_json, headers: @headers
      expect(response).to have_http_status(200)
    end

    it "returns the details of the specified employee" do
      employee_params      = { active: true, temp_hire_at: "#{Date.today}", full_time_hire_at: nil, person_id: "#{person.id}" }
      employee_params_json = employee_params.to_json

      get "/api/v1/employees/#{employee.id}", params: employee_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:employee][:id]).to eq(employee.id)
      expect(u[:employee][:active]).to eq(employee.active)
      expect(u[:employee][:temp_hire_at]).to eq(employee.temp_hire_at.strftime("%Y-%m-%d"))
      expect(u[:employee][:full_time_hire_at]).to eq(employee.full_time_hire_at)
    end

  end

  describe "Employees API Create" do

    it "returns http not authorized when not signed in" do
      employee_params      = { active: true, temp_hire_at: "#{Date.today}", full_time_hire_at: nil, person_id: "#{person.id}" }
      employee_params_json = employee_params.to_json

      sign_out login_user
      post "/api/v1/employees", params: employee_params_json, headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      employee_params      = { active: true, temp_hire_at: "#{Date.today}", full_time_hire_at: nil, person_id: "#{person.id}" }
      employee_params_json = employee_params.to_json

      post "/api/v1/employees/", params: employee_params_json, headers: @headers
      expect(response).to have_http_status(200)
    end

    it "is successful with valid parameters" do
      employee_params      = { active: true, temp_hire_at: "#{Date.today}", full_time_hire_at: nil, person_id: "#{person.id}" }
      employee_params_json = employee_params.to_json

      post "/api/v1/employees", params: employee_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:employee][:active]).to eq(employee_params[:active])
      expect(u[:employee][:temp_hire_at]).to eq(employee_params[:temp_hire_at])
      expect(u[:employee][:full_time_hire_at]).to eq(employee_params[:full_time_hire_at])
    end

    it "is not successful without a temp hire at date" do
      employee_params      = { active: true, temp_hire_at: nil, full_time_hire_at: nil, person_id: "#{person.id}" }
      employee_params_json = employee_params.to_json

      post "/api/v1/employees", params: employee_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:temp_hire_at]).to eq(["can't be blank"])
    end

    it "is not successful with a temp hire at date in the future" do
      employee_params      = { active: true, temp_hire_at: "#{Date.today + 1}", full_time_hire_at: nil, person_id: "#{person.id}" }
      employee_params_json = employee_params.to_json

      post "/api/v1/employees", params: employee_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:temp_hire_at]).to eq(["can't be in the future"])
    end

    it "returns http not found without a person id" do
      employee_params      = { active: true, temp_hire_at: "#{Date.today}", full_time_hire_at: nil, person_id: nil }
      employee_params_json = employee_params.to_json

      post "/api/v1/employees", params: employee_params_json, headers: @headers
      expect(response).to have_http_status(404)
    end

  end

  describe "Employees API Update" do

    it "returns http not authorized when not signed in" do
      employee_params      = { active: true, temp_hire_at: "#{Date.today}", full_time_hire_at: nil, person_id: "#{person.id}" }
      employee_params_json = employee_params.to_json

      sign_out login_user
      patch "/api/v1/employees/#{employee.id}", params: employee_params_json, headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      employee_params      = { active: true, temp_hire_at: "#{Date.today}", full_time_hire_at: nil, person_id: "#{person.id}" }
      employee_params_json = employee_params.to_json

      patch "/api/v1/employees/#{employee.id}", params: employee_params_json, headers: @headers
      expect(response).to have_http_status(200)
    end

    it "is successful with valid parameters" do
      employee_params      = { active: true, temp_hire_at: "#{Date.today}", full_time_hire_at: nil, person_id: "#{person.id}" }
      employee_params_json = employee_params.to_json

      patch "/api/v1/employees/#{employee.id}", params: employee_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:employee][:active]).to eq(employee_params[:active])
      expect(u[:employee][:temp_hire_at]).to eq(employee_params[:temp_hire_at])
      expect(u[:employee][:full_time_hire_at]).to eq(employee_params[:full_time_hire_at])
    end

    it "is not successful without a temp hire at date" do
      employee_params      = { active: true, temp_hire_at: nil, full_time_hire_at: nil, person_id: "#{person.id}" }
      employee_params_json = employee_params.to_json

      patch "/api/v1/employees/#{employee.id}", params: employee_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:temp_hire_at]).to eq(["can't be blank"])
    end

    it "is not successful with a temp hire at date in the future" do
      employee_params      = { active: true, temp_hire_at: "#{Date.today + 1}", full_time_hire_at: nil, person_id: "#{person.id}" }
      employee_params_json = employee_params.to_json

      patch "/api/v1/employees/#{employee.id}", params: employee_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:temp_hire_at]).to eq(["can't be in the future"])
    end

    it "is not successful without a person id" do
      employee_params      = { active: true, temp_hire_at: "#{Date.today}", full_time_hire_at: nil, person_id: nil }
      employee_params_json = employee_params.to_json

      patch "/api/v1/employees/#{employee.id}", params: employee_params_json, headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(false)
      expect(u[:errors][:person]).to eq(["must exist"])
    end

  end

  describe "Employees API Destroy" do

    it "returns http not authorized when not signed in" do
      sign_out login_user
      delete "/api/v1/employees/#{employee.id}", headers: @headers
      expect(response).to have_http_status(401)
    end

    it "returns http success when signed in" do
      delete "/api/v1/employees/#{employee.id}", headers: @headers
      expect(response).to have_http_status(200)
    end

    it "returns the list of employee without the deleted employee" do
      delete "/api/v1/employees/#{employee.id}", headers: @headers
      expect(response).to have_http_status(200)
      u = JSON.parse(response.body).deep_symbolize_keys
      expect(u[:success]).to eq(true)
      expect(u[:employees].any? { |value| employee }).to eq(false)
    end

  end

end
