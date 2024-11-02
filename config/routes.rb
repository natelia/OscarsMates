Rails.application.routes.draw do
  resources :categories
  resources :nominations
  resources :genres
  resources :users do
    member do
      post 'follow', to: 'follows#create'
      delete 'unfollow', to: 'follows#destroy'
    end
  end

  root 'movies#index'

  resources :movies do
    resources :reviews, only: [:new, :create, :destroy]
    resources :favorites, only: [:create, :destroy]
  end

  get 'signup' => 'users#new'


  get '/session', to: 'sessions#new', as: :new_session

  post '/session', to: 'sessions#create', as: :create_session
  delete '/session', to: 'sessions#destroy', as: :destroy_session

  get "signin" => "sessions#new"
end
