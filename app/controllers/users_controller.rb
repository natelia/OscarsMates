# UsersController manages the user resources, including creating new users,
# viewing user details, editing user profiles, and deleting users. It ensures
# that only authenticated and authorized users can perform certain actions.
class UsersController < ApplicationController
  before_action :require_year, only: %i[stats timeline]
  before_action :require_signin, except: %i[new create]
  before_action :require_correct_user, only: %i[edit update destroy destroy_avatar]

  # rubocop:disable Metrics/MethodLength
  def index
    @year = current_year || default_year

    # Ranking parameters
    metric = params[:metric]&.to_sym || :films
    mode = params[:mode]&.to_sym || :goals
    scope = params[:scope]&.to_sym || :mates
    @query = params[:query]

    # Initialize ranking service
    ranking_service = RankingService.new(
      year: @year,
      current_user: current_user,
      metric: metric,
      mode: mode,
      scope: scope
    )

    # Get ranked users
    @ranked_users = ranking_service.ranked_users
    @totals = ranking_service.totals
    @metric = metric
    @mode = mode
    @scope = scope

    # Apply search filter if query present
    return if @query.blank?

    @ranked_users = @ranked_users.select do |ranked_user|
      ranked_user[:user].name.downcase.include?(@query.downcase)
    end
  end
  # rubocop:enable Metrics/MethodLength

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
      # Stay on edit page if only avatar was updated
      if params[:user].keys == ['avatar']
        redirect_to edit_user_path(@user), notice: 'Avatar updated!'
      else
        redirect_to user_path(@user), notice: 'Account successfully updated!'
      end
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
