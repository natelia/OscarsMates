# FavoritesController manages the creation and deletion of favorite movies for users.
# It allows users to mark movies as favorites and remove them from their list of favorites.
class FavoritesController < ApplicationController
  before_action :require_signin
  def create
    @movie = Movie.find_by!(slug: params[:movie_id])
    @movie.favorites.create!(user: current_user)

    redirect_to @movie
  end

  def destroy
    favorite = current_user.favorites.find(params[:id])
    favorite.destroy

    @movie = Movie.find_by!(slug: params[:movie_id])
    redirect_to movie
  end
end
