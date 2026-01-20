# FavoritesController manages the creation and deletion of favorite movies for users.
# It allows users to mark movies as favorites and remove them from their list of favorites.
class FavoritesController < ApplicationController
  before_action :require_year
  before_action :require_signin
  before_action :set_movie

  def create
    favorite = @movie.favorites.new(user: current_user)
    if favorite.save
      redirect_to movie_path(@movie, year: current_year), notice: 'Movie was successfully added to favorites.'
    else
      redirect_to movie_path(@movie, year: current_year), alert: 'Could not add movie to favorites.'
    end
  end

  def destroy
    favorite = current_user.favorites.find_by!(movie: @movie)
    favorite.destroy
    redirect_to movie_path(@movie, year: current_year), notice: 'Movie was successfully removed from favorites.'
  end

  private

  # Sets the movie instance variable for create and destroy actions.
  def set_movie
    @movie = Movie.for_year(current_year).find_by!(slug: params[:movie_id])
  end
end
