Rails.application.routes.draw do
  namespace :api do
    get "/" => 'api#index'
  end

  use_doorkeeper
  devise_for :users
end
