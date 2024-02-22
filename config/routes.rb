Rails.application.routes.draw do
  root "movies#index"

  get "/movies", to: "movies#index"

end
