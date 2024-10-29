# FavoritesController manages the creation and deletion of favorite movies for users.
# It allows users to mark movies as favorites and remove them from their list of favorites.
class FavoritesController < ApplicationController
  before_action :require_signin
  before_action :set_movie

  def create
    @movie.favorites.create!(user: current_user)
    redirect_to @movie, notice: 'Movie was successfully added to favorites.'
  end

  def destroy
    favorite = current_user.favorites.find_by!(movie: @movie)
    favorite.destroy
    redirect_to @movie, notice: 'Movie was successfully removed from favorites.'
  end

  private

  # Sets the movie instance variable for create and destroy actions.
  def set_movie
    @movie = Movie.find_by!(slug: params[:movie_id])
  end
end
