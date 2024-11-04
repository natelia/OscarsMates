# ReviewsController handles the creation and deletion of reviews for movies.
# It ensures that only signed-in users can create or delete reviews.
class ReviewsController < ApplicationController
  before_action :require_signin
  before_action :set_movie

  def index
    @reviews = @movie.reviews
  end

  def new
    @review = @movie.reviews.new
  end

  def create
    @review = @movie.reviews.new(review_params)
    @review.user = current_user

    if @review.save
      redirect_to movies_path,
                  notice: 'Thanks for your review!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @review = find_review
    @review.destroy if @review

    redirect_to movies_path, notice: "Movie marked as Unwatched!"
  end

  private

  def review_params
    params.require(:review).permit(:comment, :stars)
  end

  def set_movie
    @movie = Movie.find_by!(slug: params[:movie_id])
  end

  def find_review
    current_user.reviews.find_by(movie_id: @movie.id)
  end
end
