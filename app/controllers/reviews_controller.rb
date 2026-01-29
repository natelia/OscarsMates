# ReviewsController handles the creation and deletion of reviews for movies.
# It ensures that only signed-in users can create or delete reviews.
class ReviewsController < ApplicationController
  before_action :require_year
  before_action :require_signin
  before_action :set_movie

  def index
    @reviews = @movie.reviews
  end

  def new
    @review = @movie.reviews.new
  end

  def edit
    @review = find_review
  end

  def create
    @review = @movie.reviews.new(review_params)
    @review.user = current_user
    set_watched_on_time

    if @review.save
      redirect_to movies_path(year: current_year),
                  notice: 'Thanks for your review!'
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    @review = find_review
    @review.assign_attributes(review_params)

    # Convert blank stars to nil (keeps review for date/comment but marks as unwatched)
    @review.stars = nil if params[:review][:stars].blank?

    set_watched_on_time

    if @review.save
      notice_message = @review.stars.present? ? 'Review updated!' : 'Movie marked as Unwatched!'
      redirect_to movies_path(year: current_year),
                  notice: notice_message
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @review = find_review
    @review&.destroy

    redirect_to movies_path(year: current_year), notice: 'Movie marked as Unwatched!'
  end

  private

  def review_params
    params.require(:review).permit(:comment, :stars, :watched_on)
  end

  def set_movie
    @movie = Movie.for_year(current_year).find_by!(slug: params[:movie_id])
  end

  def find_review
    current_user.reviews.find_by(movie_id: @movie.id)
  end

  def set_watched_on_time
    return if @review.watched_on.blank?

    # Date field returns datetime at midnight, so set the time to current time
    watched_date = @review.watched_on.to_date
    @review.watched_on = watched_date.to_time.change(
      hour: Time.current.hour,
      min: Time.current.min,
      sec: Time.current.sec
    )
  end
end
