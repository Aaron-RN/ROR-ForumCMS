# frozen_string_literal: true

Rails.application.routes.draw do
  root 'users#index'
  patch :logout, to: 'sessions#destroy'
  get :logged_in, to: 'sessions#logged_in'

  resources :sign_up, only: %i[create], controller: 'registrations'
  resources :log_in, only: %i[create], controller: 'sessions'
  resources :users, only: %i[index show]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
