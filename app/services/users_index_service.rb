# frozen_string_literal: true

# Service to prepare data for the users index page
# Handles filtering, sorting by watched count, and separating top watchers
class UsersIndexService
  attr_reader :year, :top_watchers, :remaining_users, :watched_counts, :total_movies_count

  def initialize(current_user:, year:, filter: nil)
    @current_user = current_user
    @year = year
    @filter = filter
  end

  def call
    load_users
    compute_watched_counts
    sort_and_separate_users
    self
  end

  private

  def load_users
    @users = UserFilterService.new(@current_user, @filter).call
    @total_movies_count = Movie.for_year(@year).count
  end

  def compute_watched_counts
    @watched_counts = Review.joins(movie: :nominations)
                            .where(nominations: { year: @year })
                            .group(:user_id)
                            .distinct
                            .count(:movie_id)
  end

  def sort_and_separate_users
    sorted_users = @users.sort_by { |u| -(@watched_counts[u.id] || 0) }

    if filtering_by_followed?
      @top_watchers = []
      @remaining_users = sorted_users
    else
      @top_watchers = sorted_users.first(3)
      @remaining_users = sorted_users.drop(3)
    end
  end

  def filtering_by_followed?
    @filter == 'followed'
  end
end
