require "sidekiq/web" # require the web UI

Rails.application.routes.draw do
  # Year selection landing page
  root 'years#index'

  # Year-scoped resources
  scope '/:year', constraints: { year: /\d{4}/ } do
    resources :movies do
      resources :reviews, only: [:index, :new, :create, :destroy]
      resources :favorites, only: [:create, :destroy]
    end

    resources :categories

    # Year-scoped user routes (viewing users, stats)
    resources :users, only: [:index, :show] do
      member do
        post 'follow', to: 'follows#create'
        delete 'unfollow', to: 'follows#destroy'
        get 'wall', to: 'users#wall'
      end
      get 'stats', on: :collection
    end
  end

  # Non-year-scoped routes
  # User account management (no year needed)
  resources :users, only: [:new, :create, :edit, :update, :destroy]

  resources :nominations
  resources :genres
  mount Sidekiq::Web => "/sidekiq"

  get 'signup' => 'users#new'
  get '/session', to: 'sessions#new', as: :new_session
  post '/session', to: 'sessions#create', as: :create_session
  delete '/session', to: 'sessions#destroy', as: :destroy_session
  get 'signin' => 'sessions#new'
end
