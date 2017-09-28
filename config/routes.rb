Rails.application.routes.draw do

  devise_for :users
  root to: 'labs#index'

  resources :labs, only: [:index]

  resources :specimen_records, only: [:new, :create]
end
