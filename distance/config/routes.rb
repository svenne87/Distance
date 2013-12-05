require 'api_constraints'

Distance::Application.routes.draw do
  namespace :api, defaults: {format: 'json'} do  
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: false) do
      resources :contacts
    end                       
    scope module: :v2, constraints: ApiConstraints.new(version: 2, default: true) do
      resources :contacts
    end
  end

  resources :contacts
  root to: 'welcome#index'
    
end
