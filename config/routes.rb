Rails.application.routes.draw do
  if Rails.env.development? || Rails.env.test?
    devise_for :users
  else
    devise_for :users,
                 controllers: {
                   omniauth_callbacks: 'users/omniauth_callbacks',
                 }, path_names: { sign_in: 'auth/shibboleth' }
  end

  resources :labs, only: [:index, :update]

  resources :sparc_requests, except: [:show] do
    member do
      patch :update_status
    end
  end

  resources :protocols, only: [:index]

  resource :protocol, only: [:show]
  resources :control_panel, only: [:index]
  resources :permissions, only: [:edit, :update]

  get 'directory/index', to: 'directory#index'

  get '/help', to: 'help#index'
  get '/404', to: 'errors#not_found'
  get '/422', to: 'errors#unacceptable'
  get '/500', to: 'errors#internal_error'

  root to: 'labs#index', constraints: lambda { |request| request.env['warden'].user ? (request.env['warden'].user.admin? || request.env['warden'].user.honest_broker.present?) : false } # we have an honest broker
  root to: 'sparc_requests#index', constraints: lambda { |request| request.env['warden'].user } # no honest broker but we are signed in

  devise_scope :user do
    root to: "devise/sessions#new"
  end
end
