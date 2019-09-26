Rails.application.routes.draw do
  devise_for :users

  resources :labs, only: [:index, :update]

  resources :sparc_requests, except: [:show] do
    member do
      patch :update_status
      get :completion_note
    end
  end

  resources :protocols, only: [:index]

  resource :protocol, only: [:show]

  get 'directory/index', to: 'directory#index'

  root to: 'labs#index', constraints: lambda { |request| request.env['warden'].user ? request.env['warden'].user.honest_broker.present? : false } # we have an honest broker
  root to: 'sparc_requests#index', constraints: lambda { |request| request.env['warden'].user } # no honest broker but we are signed in

  devise_scope :user do
    root to: "devise/sessions#new"
  end
end
