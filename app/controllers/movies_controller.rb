# MoviesController handles the CRUD operations for movies in the application.
# It allows users to view movies and admins to create, update, and delete movies.
# rubocop:disable Metrics/ClassLength
class MoviesController < ApplicationController
  MOVIE_TRANSIENT_PATH_PATTERNS = [
    %r{\A/\d{4}/movies/[^/]+/edit\z},
    %r{\A/\d{4}/movies/[^/]+/reviews/(?:new|\d+/edit)\z}
  ].freeze

  before_action :ensure_year_selected
  before_action :require_signin, except: %i[index show]
  before_action :require_admin, except: %i[index show]
  before_action :set_movie_by_slug, only: %i[show]
  before_action :set_movie_for_admin, only: %i[edit update destroy]
  before_action :set_movie_show_back_path, only: %i[show]
  before_action :set_movie_edit_context, only: %i[edit]

  def index
    @movies = ListMoviesQuery.new(params, current_user, current_year).results
    @categories = Category.for_year(current_year).order(:name)
    @selected_category = @categories.find_by(id: params[:category_id]) if params[:category_id].present?

    @user_reviews = []
    if current_user
      @user_reviews = UserMovieProgress.new(@movies, current_user).call
      calculate_progress
      calculate_user_stats
    end

    @all_movies_watched = if current_user
                            watched = current_user.watched_movies_count_for_year(current_year)
                            total = Movie.for_year(current_year).count
                            watched == total
                          else
                            false
                          end
  end

  def show
    @genres = @movie.genres.order(:name)
    @categories = @movie.categories
                        .joins(:nominations)
                        .where(nominations: { movie_id: @movie.id, year: current_year })
                        .distinct
                        .order(:name)
    @reviews = @movie.reviews.includes(:user).order(watched_on: :desc)
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
      redirect_to movie_show_path_with_back_to(safe_internal_path(params[:back_to])),
                  notice: 'Movie successfully updated!'
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

  def set_movie_by_slug
    # Admins can view any movie, others can only view movies nominated in current year
    @movie = if current_user_admin?
               Movie.find_by!(slug: params[:id])
             else
               Movie.for_year(current_year).find_by!(slug: params[:id])
             end
  end

  def set_movie
    @movie = Movie.for_year(current_year).find_by!(slug: params[:id])
  end

  def set_movie_for_admin
    @movie = Movie.find_by!(slug: params[:id])
  end

  def movie_params
    params.require(:movie).permit(:title, :english_title, :where_to_watch, :runtime, :rating, :url, :picture_url,
                                  genre_ids: [], category_ids: [], streaming_services_array: [])
  end

  def filter_movies
    @movies = MovieFilteringService.new(@movies, current_user).filter_unwatched
  end

  def search_movies
    @movies = @movies.where('title LIKE ? OR english_title LIKE ?', "%#{params[:query]}%", "%#{params[:query]}%")
  end

  def calculate_progress
    @progress = UserProgressService.new(current_user, current_year).progress if current_user
  end

  def calculate_user_stats
    return unless current_user

    ranking_service = RankingService.new(year: current_year, current_user: current_user, mode: :goals)
    user_data = ranking_service.ranked_users.find { |r| r[:user].id == current_user.id }
    @user_stats = user_data ? user_data[:stats] : nil
    @totals = ranking_service.totals
  end

  def set_users_specific_data
    @review = current_user.reviews.find_by(movie_id: @movie.id)
  end

  def set_movie_show_back_path
    @back_path = resolve_movie_back_path(fallback: movies_path(year: current_year))
  end

  def set_movie_edit_context
    @back_to = safe_internal_path(params[:back_to])
    @show_path = movie_show_path_with_back_to(@back_to)
  end

  def resolve_movie_back_path(fallback:)
    location = safe_internal_path(params[:back_to]) || safe_internal_referer_path
    return fallback if location.blank?
    return fallback if transient_movie_path?(location)

    location
  end

  def transient_movie_path?(location)
    path = path_without_query(location)

    MOVIE_TRANSIENT_PATH_PATTERNS.any? { |pattern| pattern.match?(path) }
  end

  def movie_show_path_with_back_to(back_to)
    options = { year: current_year }
    options[:back_to] = back_to if back_to.present?
    movie_path(@movie, options)
  end
end
# rubocop:enable Metrics/ClassLength
