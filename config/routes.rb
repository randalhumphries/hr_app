Rails.application.routes.draw do

  namespace :api do
    get "/" => 'api#index'
    get "/v1" => "v1#index"
    get "/v1/not_found" => 'v1#test_not_found'
    get "/v1/not_authorized" => 'v1#test_not_authorized'
    get "/v1/application_error" => 'v1#test_application_error'
  end

  use_doorkeeper
  devise_for :users
end