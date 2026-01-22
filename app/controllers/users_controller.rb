# UsersController manages the user resources, including creating new users,
# viewing user details, editing user profiles, and deleting users. It ensures
# that only authenticated and authorized users can perform certain actions.
class UsersController < ApplicationController
  before_action :require_year, only: %i[stats timeline]
  before_action :require_signin, except: %i[new create]
  before_action :require_correct_user, only: %i[edit update destroy destroy_avatar]

  def index
    @users = User.all
    @year = current_year || default_year
    @total_movies_count = Movie.for_year(@year).count

    @users = UserFilterService.new(current_user, params[:filter]).call

    # Calculate top watchers for podium display
    @top_watchers = @users.sort_by { |u| -u.watched_movies_count_for_year(@year) }.first(3)

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

  def destroy_avatar
    @user.avatar.purge
    redirect_to edit_user_path(@user), notice: 'Avatar removed!'
  end

  def stats
    @user = current_user
    stats_service = UserStatsService.new(@user, current_year)

    @total_movies_watched = stats_service.user_stats[:total_movies_watched]
    @total_minutes_watched = stats_service.user_stats[:total_minutes_watched]
    @mates_stats = stats_service.mates_stats || []
  end

  def timeline
    @user = current_user
    @page = params[:page]&.to_i || 1
    @mates_reviews = MatesReviewsQuery.new(current_user, current_year, limit: 8, page: @page).results

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  private

  def require_correct_user
    @user = User.find(params[:id])
    redirect_to root_url, status: :see_other unless current_user?(@user)
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :avatar)
  end
end
