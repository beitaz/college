Rails.application.routes.draw do
  # devise_for :users
  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    passwords: 'users/passwords',
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    unlocks: 'users/unlocks'
  }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'home', to: 'users#home'
  get 'profile', to: 'users#profile'
  post 'setting', to: 'users#setting'
  # delete 'logout', to: 'users#logout'
  # post 'signin', to: 'users#signin'
  # get 'login', to: 'users#login'
  get 'users', to: 'users#index'
  get 'about', to: 'static#about'
  get 'index', to: 'static#index'
  root 'static#index'
end
