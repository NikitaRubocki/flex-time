Rails.application.routes.draw do

  root to: 'activities#index'

  # https://github.com/zquestz/omniauth-google-oauth2
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :activities
  resources :teachers, except: [:new]
  resources :students, only: [:index, :show, :update]

end
