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

    @mates_stats = mates_stats(@mates)

    all_dates = @mates_stats.flat_map { |mate| mate[:daily_minutes_watched].keys }.uniq
    date_range = (all_dates.min..all_dates.max).to_a

    @mates_minutes_watched = @mates_stats.flat_map do |mate|
      next [] if mate[:daily_minutes_watched].empty?
      
      previous_value = 0
      date_range.map do |date|
        current_value = mate[:daily_minutes_watched][date] || previous_value
        previous_value = current_value
        { 
          name: mate[:name],
          date: date,
          minutes_watched: current_value
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
    daily_minutes = user.reviews
                       .joins(:movie)
                       .group('DATE(reviews.watched_on)')
                       .sum('movies.runtime')
                       .transform_keys(&:to_date)
  
    # Sort by date and calculate cumulative sum
    cumulative_sum = 0
    daily_minutes.sort.to_h.transform_values do |minutes|
      cumulative_sum += minutes
    end
  end

  def total_minutes_watched(user)
    user.reviews.joins(:movie).sum('movies.runtime')
  end

  def mates_stats(mates)
    all_users = [current_user] + mates
    all_users.map do |user|
      {
        name: user.name,
        total_movies_watched: user.reviews.count,
        total_minutes_watched: total_minutes_watched(user),
        daily_minutes_watched: user_daily_minutes_watched(user)
      }
    end
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
