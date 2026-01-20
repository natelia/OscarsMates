# frozen_string_literal: true

# Retrieves user's review progress for a collection of movies
class UserMovieProgress < ApplicationService
  def initialize(movies:, user:)
    @movies = movies
    @user = user
  end

  def call
    reviews_map = build_reviews_map
    ServiceResult.success(reviews_map)
  rescue StandardError => e
    ServiceResult.failure(e.message)
  end

  private

  attr_reader :movies, :user

  def build_reviews_map
    return {} unless user

    reviews = user.reviews.where(movie: movies)
    reviews.index_by(&:movie_id)
  end
end
