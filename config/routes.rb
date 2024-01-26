Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'users/sessions#new'

  # Routes for Google authentication
  get 'auth/:provider/callback', to: 'users/sessions#create'
  delete '/logout', to: 'users/sessions#destroy'

  resources :events
end
