Rails.application.routes.draw do
  devise_for :users
  root 'pages#landing'
  get :home, to: 'pages#home'

  post :subscribe, to: 'pages#subscribe'
end
