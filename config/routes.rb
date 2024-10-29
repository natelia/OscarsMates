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

  resource :session, only: [:new, :create, :destroy]

  get "signin" => "sessions#new"
end
