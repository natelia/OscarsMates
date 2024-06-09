class FavoritesController < ApplicationController
  before_action :require_signin
    def create
      @movie = Movie.find(params[:movie_id])
      @movie.favorites.create!

      redirect_to @movie
    end
end
