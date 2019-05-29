Rails.application.routes.draw do
  devise_for :users

  resources :labs, only: [:index, :update]

  resources :specimen_records, only: [:new, :create]

  resources :sparc_requests, except: [:show] do
    member do
      patch :update_status
    end
  end

  resources :protocols, only: [:index]

  resource :protocol, only: [:show]

  get 'directory/index', to: 'directory#index'
  get 'labs/update', to: 'labs#update'

  root to: 'labs#index', constraints: lambda { |request| request.env['warden'].user ? request.env['warden'].user.honest_broker? : false } # we have an honest broker
  root to: 'sparc_requests#index', constraints: lambda { |request| request.env['warden'].user } # no honest broker but we are signed in

  devise_scope :user do
    root to: "devise/sessions#new"
  end
end
