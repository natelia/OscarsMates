Rails.application.routes.draw do
  resources :genres
  resources :users
  root 'movies#index'

  resources :movies do
    resources :reviews
    resources :favorites, only: [:create, :destroy]
  end

  get 'signup' => 'users#new'

  resource :session, only: [:new, :create, :destroy]

  get "signin" => "sessions#new"
end
