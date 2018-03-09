Rails.application.routes.draw do

  namespace :api do
    get "/" => 'api#index'
    get "/v1" => "v1#index"
    get "/v1/not_found" => 'v1#test_not_found'
    get "/v1/not_authorized" => 'v1#test_not_authorized'
    get "/v1/application_error" => 'v1#test_application_error'

    namespace :v1 do
      namespace :admin do
        resources :users, except: [ :new, :edit ]
        resources :races, except: [ :new, :edit ]
        resources :ethnicities, except: [ :new, :edit ]
        resources :benefit_types, except: [ :new, :edit ]
        resources :remuneration_types, except: [ :new, :edit ]
        resources :assignment_types, except: [ :new, :edit ]
        resources :contact_types, except: [ :new, :edit ]
      end
    end

  end

  use_doorkeeper
  devise_for :users
end