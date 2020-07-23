Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  if Rails.env.development? || Rails.env.test?
    devise_for :users
  else
    devise_for :users,
                 controllers: {
                   omniauth_callbacks: 'users/omniauth_callbacks',
                 }, path_names: { sign_in: 'auth/shibboleth' }
  end

  resources :labs, only: [:index, :update]

  get '/specimens', to: 'labs#index', as: 'specimens'

  resources :sparc_requests do
    member do
      patch :update_status
    end
  end

  get '/requests', to: 'sparc_requests#index', as: 'requests'
  get '/requests/:id/', to: 'sparc_requests#show', as: 'request'

  resources :protocols, only: [:index]
  resource :protocol, only: [:show]

  namespace :control_panel do
    resources :users, only: [:index, :edit, :update]
    resources :groups, only: [:index, :edit, :update] do
      resources :lab_honest_brokers, only: [:index, :new, :create] do
        collection do
          delete :destroy
        end
      end
    end

    root to: 'users#index'
  end

  resources :i2b2_queries, only: [:index]

  get 'directory/index', to: 'directory#index'

  namespace :sparc do
    get '/directory/index', to: 'directory#index'
  end

  get '/help', to: 'pages#help', as: 'help'

  get '/404', to: 'errors#not_found'
  get '/422', to: 'errors#unacceptable'
  get '/500', to: 'errors#internal_error'

  root to: 'labs#index', constraints: lambda { |request| request.env['warden'].user ? (request.env['warden'].user.admin? || request.env['warden'].user.lab_honest_broker?) : false } # we have an honest broker
  root to: 'sparc_requests#index', constraints: lambda { |request| request.env['warden'].user } # no honest broker but we are signed in

  devise_scope :user do
    root to: "devise/sessions#new"
  end
end
