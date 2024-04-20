Rails.application.routes.draw do
  resources :users
  root 'movies#index'

  resources :movies do
    resources :reviews
  end

end
