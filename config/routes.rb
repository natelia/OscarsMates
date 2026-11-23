require 'sidekiq/web' # require the web UI

Rails.application.routes.draw do
  get 'design_system/index'
  # Health check endpoint for Docker
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Root redirects to movies (will auto-select latest year)
  root 'movies#index'

  # Year-scoped resources (content that varies by year)
  scope '/:year', constraints: { year: /\d{4}/ } do
    resources :movies do
      resources :reviews, only: %i[index new create edit update destroy]
      resources :favorites, only: %i[create destroy]
    end

    resources :categories
    resources :user_picks, only: %i[create destroy]

    # User-related year-scoped pages
    get 'stats', to: 'users#stats', as: :stats_users
    get 'timeline', to: 'users#timeline', as: :timeline_users
  end

  # User profiles (NOT year-scoped)
  resources :users do
    member do
      post 'follow', to: 'follows#create'
      delete 'unfollow', to: 'follows#destroy'
      delete 'avatar', to: 'users#destroy_avatar'
    end
  end

  resources :nominations
  resources :genres
  mount Sidekiq::Web => '/sidekiq'

  get 'signup' => 'users#new'
  get '/session', to: 'sessions#new', as: :new_session
  post '/session', to: 'sessions#create', as: :create_session
  delete '/session', to: 'sessions#destroy', as: :destroy_session
  get 'signin' => 'sessions#new'

  # Static pages
  get 'about', to: 'pages#about', as: :about

  # Feedback forms
  get 'report-bug', to: 'feedback#report_bug', as: :report_bug
  post 'report-bug', to: 'feedback#submit_bug'
  get 'request-feature', to: 'feedback#request_feature', as: :request_feature
  post 'request-feature', to: 'feedback#submit_feature'
end
