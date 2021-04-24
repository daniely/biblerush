Rails.application.routes.draw do
  devise_for :users
  root 'pages#landing', as: :user_root
  get '/welcome' => "pages#welcome"
  get :home, to: 'pages#home'
  get :how_it_works, to: 'pages#how_it_works'
  get :about, to: 'pages#about'
  get :terms, to: 'pages#terms'

  get :message, to: 'pages#message'
  post :subscribe, to: 'pages#subscribe'
  get :congratz, to: 'pages#congratz'

  resources :reading_plans
  resources :subscriptions, only: [:create, :show, :index] do
    # make inactive
    get :pause
    # make active
    get :resume
  end

  resources :plan_jobs, only: [:show] do
    post :mark_read
    get  :mark_read
  end
end
