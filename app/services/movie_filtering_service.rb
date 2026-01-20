# frozen_string_literal: true

# Filters movies based on user watch status
class MovieFilteringService < ApplicationService
  def initialize(movies:, user:, filter: nil)
    @movies = movies
    @user = user
    @filter = filter
  end

  def call
    filtered = apply_filter
    ServiceResult.success(filtered)
  rescue StandardError => e
    ServiceResult.failure(e.message)
  end

  private

  attr_reader :movies, :user, :filter

  def apply_filter
    case filter
    when 'unwatched'
      filter_unwatched
    when 'watched'
      filter_watched
    else
      movies
    end
  end

  def filter_unwatched
    return movies unless user

    reviewed_movie_ids = user.reviews.pluck(:movie_id)
    movies.where.not(id: reviewed_movie_ids)
  end

  def filter_watched
    return movies.none unless user

    reviewed_movie_ids = user.reviews.pluck(:movie_id)
    movies.where(id: reviewed_movie_ids)
  end
end
