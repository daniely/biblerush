Rails.application.routes.draw do
  devise_for :users
  # redirect here after new user signs up
  get '/welcome' => "pages#welcome", as: :user_root

  root 'pages#landing'
  get :home, to: 'pages#home'

  post :subscribe, to: 'pages#subscribe'

  resources :reading_plans
  resources :subscriptions, only: [:create, :show, :index]
  resources :plan_jobs, only: [:show] do
    post :mark_read
  end
end
