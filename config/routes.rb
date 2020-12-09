Rails.application.routes.draw do
  devise_for :users
  # redirect here after new user signs up
  get '/welcome' => "pages#welcome", as: :user_root

  root 'pages#landing'
  get :home, to: 'pages#home'

  post :subscribe, to: 'pages#subscribe'

  get :progress, to: 'pages#progress'

  resources :reading_plans
end
