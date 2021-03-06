Rails.application.routes.draw do

  namespace :api do
    get "/" => 'api#index'
    get "/v1" => "v1#index"
    get "/v1/not_found" => 'v1#test_not_found'
    get "/v1/not_authorized" => 'v1#test_not_authorized'
    get "/v1/application_error" => 'v1#test_application_error'

    namespace :v1 do
      resources :people, except: [ :new, :edit ] do
        resources :contacts, except: [ :new, :edit ]
        resources :emergency_contacts, except: [ :new, :edit ]
        resources :addresses, except: [ :new, :edit ]
        resources :certifications, except: [ :new, :edit ]
      end
      resources :employees, except: [ :new, :edit ] do
        resources :benefits, except: [ :new, :edit ]
      end
      namespace :admin do
        resources :users, except: [ :new, :edit ]
        resources :races, except: [ :new, :edit ]
        resources :ethnicities, except: [ :new, :edit ]
        resources :benefit_types, except: [ :new, :edit ]
        resources :remuneration_types, except: [ :new, :edit ]
        resources :assignment_types, except: [ :new, :edit ]
        resources :contact_types, except: [ :new, :edit ]
        resources :certification_types, except: [ :new, :edit ]
        resources :relationship_types, except: [ :new, :edit ]
        resources :companies, except: [ :new, :edit ]
        resources :company_units, except: [ :new, :edit ]
      end
    end

  end

  use_doorkeeper
  devise_for :users
end