Rails.application.routes.draw do

  resources :registrations
  root to: 'students#show', constraints: lambda { |req| req.env['warden'].user&.student? }
  root to: 'activities#index'

  # https://github.com/zquestz/omniauth-google-oauth2
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :activities
  resources :teachers, except: [:new]
  resources :students, only: [:index, :show, :update]

end
