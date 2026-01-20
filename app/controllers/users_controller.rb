# UsersController manages the user resources, including creating new users,
# viewing user details, editing user profiles, and deleting users. It ensures
# that only authenticated and authorized users can perform certain actions.
class UsersController < ApplicationController
  before_action :require_year, only: %i[stats]
  before_action :require_signin, except: %i[new create]
  before_action :require_correct_user, only: %i[edit update destroy]

  def index
    @users = User.all
    @year = current_year || default_year
    @total_movies_count = Movie.for_year(@year).count

    @users = UserFilterService.new(current_user, params[:filter]).call

    # Precompute watched counts for all users to avoid N+1 queries
    @watched_counts = Review.joins(movie: :nominations)
                            .where(nominations: { year: @year })
                            .group(:user_id)
                            .distinct
                            .count(:movie_id)

    # Calculate top watchers for podium display using precomputed counts
    @top_watchers = @users.sort_by { |u| -(@watched_counts[u.id] || 0) }.first(3)

    # Exclude top watchers from main list to avoid duplication
    @remaining_users = @users - @top_watchers
  end

  def show
    @user = User.find(params[:id])
    year = current_year || default_year
    @reviews = @user.reviews_for_year(year).includes(:movie).order(watched_on: :desc, created_at: :desc)
    @favorite_movies = @user.favorite_movies.for_year(year)
    @progress = UserProgressService.new(@user, year).progress
    @top_rated_movies = @user.reviews_for_year(year).order(stars: :desc).limit(3).map(&:movie)
  end

  def new
    @user = User.new
  end

  def edit; end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: 'Thanks for signing up!'
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @user.update(user_params)
      redirect_to root_path, notice: 'Account successfully updated!'
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @user.destroy
    session[:user_id] = nil
    redirect_to root_path, status: :see_other,
                           alert: 'Account successfully deleted!'
  end

  def stats
    @user = current_user
    stats_service = UserStatsService.new(@user, current_year)

    @total_movies_watched = stats_service.user_stats[:total_movies_watched]
    @total_minutes_watched = stats_service.user_stats[:total_minutes_watched]
    @mates_stats = stats_service.mates_stats || []

    @mates_reviews = MatesReviewsQuery.new(current_user, current_year).results
  end

  private

  def require_correct_user
    @user = User.find(params[:id])
    redirect_to root_url, status: :see_other unless current_user?(@user)
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
