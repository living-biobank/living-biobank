Rails.application.routes.draw do

  devise_for :users
  root to: 'labs#index'

  resources :labs, only: [:index, :update]

  resources :specimen_records, only: [:new, :create]
  resources :sparc_requests, only: [:new, :create]
end
