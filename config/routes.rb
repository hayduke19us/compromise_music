CompromiseMusic::Application.routes.draw do

  match 'auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  match 'signout', to: 'sessions#destroy', as: 'signout', via: [:get, :post]

  get "playlists/search"
  get "sessions/index"

  resources :friendships

  resources :users do
    resources :friends
  end

  resources :users do
    resources :playlists
  end

  resources :tracks do
    member do
      get :vote_up, as: 'vote_up'
      get :vote_down, as: 'vote_down'
    end
  end

  resources :playlists do
    member do
      get :publish, as: 'publish'
      get :music_box
    end
  end

  resources :users do
    resources :groups
  end
  
  resources :groups do
   resources :playlists
  end
  

  resources :grouplists
  resources :groupships
  root "sessions#index"
end
