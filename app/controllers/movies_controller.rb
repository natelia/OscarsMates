# MoviesController handles the CRUD operations for movies in the application.
# It allows users to view movies and admins to create, update, and delete movies.
class MoviesController < ApplicationController
  before_action :require_signin, except: %i[index show]
  before_action :require_admin, except: %i[index show]
  before_action :set_movie, only: %i[show edit update destroy]

  def index
    @movies = Movie.all
    if current_user
    @user_reviews = current_user.reviews.where(movie: @movies).index_by(&:movie_id) 
    filter_unwatched_movies if params[:filter] == 'unwatched'
    calculate_progress
    end
    search_movies if params[:query].present?
  end

  def show
    @fans = @movie.fans
    @genres = @movie.genres.order(:name)
    @categories = @movie.categories.order(:name)
    set_users_specific_data if current_user
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

  def edit; end

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
    params.require(:movie).permit(:title, :english_title, :where_to_watch, :runtime, :rating, :url, :picture_url, genre_ids: [], category_ids: [])
  end

  def filter_unwatched_movies
    @movies = @movies.left_joins(:reviews)
                       .where(reviews: {user_id: nil})
  end

  def search_movies
    @movies = @movies.where('title LIKE ?', "%#{params[:query]}%")
  end

  def calculate_progress
    @watched_movies_count = current_user.reviews.count
    @total_movies_count = Movie.count
    @progress = @watched_movies_count.to_f / @total_movies_count * 100
  end

  def set_users_specific_data
    @favorite = current_user.favorites.find_by(movie_id: @movie.id)
    @review = current_user.reviews.find_by(movie_id: @movie.id) 
  end
end
