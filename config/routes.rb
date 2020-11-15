# frozen_string_literal: true

Rails.application.routes.draw do
  root 'users#index'
  patch :logout, to: 'sessions#destroy'
  get :logged_in, to: 'sessions#logged_in'
  post '/registrations/:id/activate_account/:activation_key',
       to: 'registrations#activate_account'

  resources :comments, only: %i[show create update destroy]
  resources :posts, only: %i[show create update destroy] do
    member do
      patch :lock_post, to: 'posts#lock_post'
      patch :pin_post, to: 'posts#pin_post'
    end
  end
  resources :forums, only: %i[index show create update destroy]
  resources :sign_up, only: %i[create], controller: 'registrations'
  resources :log_in, only: %i[create], controller: 'sessions'
  resources :users, only: %i[index show] do
    member do
      patch :set_admin_level, to: 'users#set_admin_level'
      patch :suspend_comms, to: 'users#suspend_communication'
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
