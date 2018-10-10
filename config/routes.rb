Rails.application.routes.draw do

  devise_for :users

  resources :labs, only: [:index, :update]

  resources :specimen_records, only: [:new, :create]

  resources :sparc_requests, only: [:index, :new, :create, :edit, :update, :destroy] do
    patch :update_status
  end

  get '/directory/search', to: 'directory#search'

  root to: 'labs#index', constraints: lambda { |request| request.env['warden'].user ? request.env['warden'].user.honest_broker? : false } # we have an honest broker
  root to: 'sparc_requests#index', constraints: lambda { |request| request.env['warden'].user } # no honest broker but we are signed in

  devise_scope :user do
    root to: "devise/sessions#new"
  end
end
