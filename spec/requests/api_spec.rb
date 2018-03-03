require 'rails_helper'

RSpec.describe "Base API", type: :request do

  it 'responds with a success message' do
    get api_path, params: nil, headers: {'HTTP_ACCEPT' => "application/json"}
    expect(response.status).to eq(200)
    u = JSON.parse(response.body).deep_symbolize_keys
    expect(u[:success]).to eq(true)
    expect(u[:message]).to eq("Hello!")
  end

end