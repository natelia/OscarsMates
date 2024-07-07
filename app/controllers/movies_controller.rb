# MoviesController handles the CRUD operations for movies in the application.
# It allows users to view movies and admins to create, update, and delete movies.
class MoviesController < ApplicationController
  before_action :require_signin, except: %i[index show]
  before_action :require_admin, except: %i[index show]
  before_action :set_movie, only: %i[show edit update destroy]

  def index
    @movies = Movie.all
  end

  def show
    @fans = @movie.fans
    @genres = @movie.genres.order(:name)
    @favorite = current_user.favorites.find_by(movie_id: @movie.id) if current_user
  end

  def new
    @movie = Movie.new
  end

  def create
    @movie = Movie.new(movie_params)

    if @movie.save
      redirect_to @movie, notice: 'Movie successfully created!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @movie.update(movie_params)
      redirect_to @movie, notice: 'Movie successfully updated!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @movie.destroy
    redirect_to root_path, status: :see_other, alert: 'Movie successfully deleted!'
  end

  private

  def set_movie
    @movie = Movie.find_by!(slug: params[:id])
  end

  def movie_params
    params.require(:movie).permit(:title, :english_title, :where_to_watch, :runtime, :rating, :url, :picture_url, genre_ids: [])
  end
end
