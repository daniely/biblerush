Rails.application.routes.draw do
  devise_for :users
  root 'pages#landing', as: :user_root
  get '/welcome' => "pages#welcome"
  get :home, to: 'pages#home'

  post :subscribe, to: 'pages#subscribe'

  resources :reading_plans
  resources :subscriptions, only: [:create, :show, :index]
  resources :plan_jobs, only: [:show] do
    post :mark_read
  end
end
