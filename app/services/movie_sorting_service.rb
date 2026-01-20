# frozen_string_literal: true

# Sorts movies based on various criteria
class MovieSortingService < ApplicationService
  def initialize(movies:, sort_by:, user: nil)
    @movies = movies
    @sort_by = sort_by
    @user = user
  end

  def call
    sorted = apply_sort
    ServiceResult.success(sorted)
  rescue StandardError => e
    ServiceResult.failure(e.message)
  end

  private

  attr_reader :movies, :sort_by, :user

  def apply_sort
    case sort_by
    when 'duration'
      sort_by_duration
    when 'watched_by_mates'
      sort_by_mates_watched
    when 'most_nominated'
      sort_by_nominations
    else
      sort_by_title
    end
  end

  def sort_by_duration
    movies.order(runtime: :desc)
  end

  def sort_by_mates_watched
    return sort_by_title unless user

    mate_ids = user.following.pluck(:id)
    return sort_by_title if mate_ids.empty?

    movies.joins(:reviews)
          .where(reviews: { user_id: mate_ids })
          .group('movies.id')
          .order('COUNT(reviews.id) DESC')
  end

  def sort_by_nominations
    movies.joins(:categories)
          .group('movies.id')
          .order('COUNT(categories.id) DESC')
  end

  def sort_by_title
    movies.order(:title)
  end
end
