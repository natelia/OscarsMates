# ReviewsController handles the creation and deletion of reviews for movies.
# It ensures that only signed-in users can create or delete reviews.
class ReviewsController < ApplicationController
  REVIEW_FORM_PATH_PATTERN = %r{\A/\d{4}/movies/[^/]+/reviews/(?:new|\d+/edit)\z}

  before_action :require_year
  before_action :require_signin
  before_action :set_movie
  before_action :set_return_to_path, only: %i[new edit]

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
      redirect_to return_location,
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
      redirect_to return_location,
                  notice: notice_message
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @review = find_review
    @review&.destroy

    redirect_to return_location(fallback: movie_path(@movie, year: current_year)),
                notice: 'Movie marked as Unwatched!'
  end

  private

  def set_return_to_path
    @return_to_path = return_location(fallback: movie_path(@movie, year: current_year))
  end

  def return_location(fallback: movies_path(year: current_year))
    location = safe_internal_path(params[:return_to]) || safe_internal_referer_path
    return fallback if location.blank?
    return fallback if review_form_path?(location)

    location
  end

  def review_form_path?(location)
    REVIEW_FORM_PATH_PATTERN.match?(path_without_query(location))
  end

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
