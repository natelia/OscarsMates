# UsersController manages the user resources, including creating new users,
# viewing user details, editing user profiles, and deleting users. It ensures
# that only authenticated and authorized users can perform certain actions.
class UsersController < ApplicationController
  before_action :require_signin, except: %i[new create]
  before_action :require_correct_user, only: %i[edit update destroy]

  def index
    @users = User.all
    @total_movies_count = Movie.count

    return unless params[:filter] == 'followed' && current_user

    @users = current_user.following
  end

  def show
    @user = User.find(params[:id])
    @reviews = @user.reviews
    @favorite_movies = @user.favorite_movies
    total_movies = Movie.count
    watched_movies = @user.reviews.count
    @progress = (watched_movies.to_f / total_movies) * 100
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to movies_path, notice: 'Thanks for signing up!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'Account successfully updated!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    session[:user_id] = nil
    redirect_to movies_url, status: :see_other,
                            alert: 'Account successfully deleted!'
  end

  def stats
    @user = current_user
    @mates = @user.following

    @total_movies_watched = @user.reviews.count
    @total_minutes_watched = total_minutes_watched(@user)

    @user_daily_minutes_watched = user_daily_minutes_watched(@user)
    @mates_stats = mates_stats(@mates)

    @mates_minutes_watched = @mates_stats.flat_map do |mate|
      dates = mate[:daily_minutes_watched].keys
      next [] if dates.empty?
      
      date_range = (dates.min..dates.max).to_a
      
      date_range.map do |date|
        { 
          name: mate[:name],
          date: date,
          minutes_watched: mate[:daily_minutes_watched][date] || 0
        }
      end
    end
  end

  private

  def require_correct_user
    @user = User.find(params[:id])
    redirect_to root_url, status: :see_other unless current_user?(@user)
  end

  def user_daily_minutes_watched(user)
    user.reviews
        .joins(:movie)
        .group('DATE(reviews.created_at)')
        .sum('movies.runtime')
        .transform_keys { |date_str| Date.parse(date_str) }
  end

  def total_minutes_watched(user)
    user.reviews.joins(:movie).sum('movies.runtime')
  end

  def mates_stats(mates)
    mates.map do |mate|
      {
        name: mate.name,
        total_movies_watched: mate.reviews.count,
        total_minutes_watched: total_minutes_watched(mate),
        daily_minutes_watched: user_daily_minutes_watched(mate)
      }
    end
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
