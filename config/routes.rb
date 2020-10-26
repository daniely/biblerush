Rails.application.routes.draw do
  root 'pages#landing'
  get :home, to: 'pages#home'
end
