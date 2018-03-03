Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users

  namespace :api do
    get "/" => "api#index"
  end
end
