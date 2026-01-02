require "sidekiq/web" # require the web UI

Rails.application.routes.draw do
  # Health check endpoint for Docker
  get "up" => "rails/health#show", as: :rails_health_check

  # Root redirects to movies (will auto-select latest year)
  root 'movies#index'

  # Year-scoped resources (content that varies by year)
  scope '/:year', constraints: { year: /\d{4}/ } do
    resources :movies do
      resources :reviews, only: [:index, :new, :create, :destroy]
      resources :favorites, only: [:create, :destroy]
    end

    resources :categories

    # Only stats is year-scoped
    get 'stats', to: 'users#stats', as: :stats_users
  end

  # User profiles (NOT year-scoped)
  resources :users do
    member do
      post 'follow', to: 'follows#create'
      delete 'unfollow', to: 'follows#destroy'
    end
  end

  resources :nominations
  resources :genres
  mount Sidekiq::Web => "/sidekiq"

  get 'signup' => 'users#new'
  get '/session', to: 'sessions#new', as: :new_session
  post '/session', to: 'sessions#create', as: :create_session
  delete '/session', to: 'sessions#destroy', as: :destroy_session
  get 'signin' => 'sessions#new'
end
