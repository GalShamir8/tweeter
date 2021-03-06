Rails.application.routes.draw do
  resources :followers
  resources :tweets
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  get '/users/search', to: 'users#search'
  get 'users/followers', to: 'users#followers'
  get 'users/following', to: 'users#following'
  resources :users
  root 'home#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
