Rails.application.routes.draw do
  root "movies#index"

  get "/movies", to: "movies#index"
  get "/movies/:id", to: "movies#show"

end
