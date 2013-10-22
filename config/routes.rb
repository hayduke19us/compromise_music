CompromiseMusic::Application.routes.draw do

  match 'auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  match 'signout', to: 'sessions#destroy', as: 'signout', via: [:get, :post]

  get "sessions/index"

  resources :friendships
  resources :users 
  resources :playlists
  resources :tracks 

  root "sessions#index"

end
