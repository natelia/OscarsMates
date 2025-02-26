# MoviesController handles the CRUD operations for movies in the application.
# It allows users to view movies and admins to create, update, and delete movies.
class MoviesController < ApplicationController
  before_action :require_signin, except: %i[index show]
  before_action :require_admin, except: %i[index show]
  before_action :set_movie, only: %i[show edit update destroy]

  def index
    @movies = Movie.all
    @user_reviews = []

    if current_user
      @user_reviews = current_user.reviews.where(movie: @movies).index_by(&:movie_id)
      filter_unwatched_movies if params[:filter] == 'unwatched'
      calculate_progress
    end

    search_movies if params[:query].present?
    sort_movies
    @all_movies_watched = current_user.reviews.count == Movie.count
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

  def import
    if params[:file].present?
      CSV.foreach(params[:file].path, headers: true) do |row|
        Movie.create!(row.to_h)
      end
      redirect_to movies_path, notice: 'Movies imported successfully!'
    else
      redirect_to movies_path, alert: 'Please upload a CSV file.'
    end
  end  

 
  private

  def sort_movies
    @movies = case params[:sort_by]
    when 'duration'
      @movies.order(runtime: :desc)
    when 'watched_by_mates'
      mate_ids = current_user.following.pluck(:id)
      @movies.joins(:reviews)
             .where(reviews: { user_id: mate_ids })
             .group('movies.id')
             .order('COUNT(reviews.id) DESC')
    when 'most_nominated'
      @movies.joins(:categories)
             .group('movies.id')
             .order('COUNT(categories.id) DESC')
    else
      @movies.order(:title)
    end
  end


  def set_movie
    @movie = Movie.find_by!(slug: params[:id])
  end

  def movie_params
    params.require(:movie).permit(:title, :english_title, :where_to_watch, :runtime, :rating, :url, :picture_url, genre_ids: [], category_ids: [])
  end

  def filter_unwatched_movies
    @movies = @movies.left_joins(:reviews)
                   .where.not(reviews: { user_id: current_user.id })
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
