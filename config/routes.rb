require 'api_constraints'
Rails.application.routes.draw do
  root "rails/welcome#index"
  devise_for :users
  
  devise_scope :user do
    get '/signout', to: 'devise/sessions#destroy', as: :signout
  end
  
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  namespace :api, defaults: { format: :json } do
    scope module: :v1,
            constraints: ApiConstraints.new(version: 1, default: true) do
      post 'login_api' => 'users#login_api'
    end
  end
  
end
