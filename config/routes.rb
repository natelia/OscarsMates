Rails.application.routes.draw do
  resources :favorites
  resources :users
  root 'movies#index'

  resources :movies do
    resources :reviews
  end

  get 'signup' => 'users#new'

  resource :session, only: [:new, :create, :destroy]

  get "signin" => "sessions#new"
end
