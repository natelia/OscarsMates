# MoviesController handles the CRUD operations for movies in the application.
# It allows users to view movies and admins to create, update, and delete movies.
class MoviesController < ApplicationController
  before_action :ensure_year_selected
  before_action :require_signin, except: %i[index show]
  before_action :require_admin, except: %i[index show]
  before_action :set_movie, only: %i[show edit update destroy]

  def index
    movies_query = ListMoviesQuery.new(params, current_user, current_year).results
    @pagy, @movies = pagy(movies_query)

    @user_reviews = {}
    if current_user
      @user_reviews = UserMovieProgress.new(@movies, current_user).call
      calculate_progress
    end

    @all_movies_watched = current_user ? all_movies_watched? : false
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

  def edit; end

  def create
    @movie = Movie.new(movie_params)
    if @movie.save
      redirect_to movie_path(@movie, year: current_year), notice: 'Movie successfully created!'
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @movie.update(movie_params)
      redirect_to movie_path(@movie, year: current_year), notice: 'Movie successfully updated!'
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @movie.destroy
    redirect_to movies_path(year: current_year), status: :see_other, alert: 'Movie successfully deleted!'
  end

  private

  def ensure_year_selected
    return if current_year.present?

    redirect_to movies_path(year: default_year)
  end

  def sort_movies
    @movies = MovieSortingService.new(@movies, params[:sort_by], current_user).call
  end

  def set_movie
    @movie = Movie.for_year(current_year).find_by!(slug: params[:id])
  end

  def movie_params
    params.require(:movie).permit(:title, :english_title, :where_to_watch, :runtime, :rating, :url, :picture_url,
                                  genre_ids: [], category_ids: [])
  end

  def filter_movies
    @movies = MovieFilteringService.new(@movies, current_user).filter_unwatched
  end

  def search_movies
    @movies = @movies.where('title LIKE ?', "%#{params[:query]}%")
  end

  def calculate_progress
    @progress = UserProgressService.new(current_user, current_year).progress if current_user
  end

  def set_users_specific_data
    @favorite = current_user.favorites.find_by(movie_id: @movie.id)
    @review = current_user.reviews.find_by(movie_id: @movie.id)
  end

  def all_movies_watched?
    watched = current_user.watched_movies_count_for_year(current_year)
    total = Movie.for_year(current_year).count
    total.positive? && watched == total
  end
end
