# UsersController manages the user resources, including creating new users,
# viewing user details, editing user profiles, and deleting users. It ensures
# that only authenticated and authorized users can perform certain actions.
class UsersController < ApplicationController
  before_action :require_year, only: %i[stats]
  before_action :require_signin, except: %i[new create]
  before_action :require_correct_user, only: %i[edit update destroy]

  def index
    @year = current_year || default_year

    service = UsersIndexService.new(
      current_user: current_user,
      year: @year,
      filter: params[:filter]
    ).call

    @total_movies_count = service.total_movies_count
    @watched_counts = service.watched_counts
    @top_watchers = service.top_watchers
    @pagy, @remaining_users = pagy_array(service.remaining_users)
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
