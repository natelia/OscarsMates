# frozen_string_literal: true

# Calculates user's progress in watching movies for a given year
class UserProgressService < ApplicationService
  def initialize(user:, year:)
    @user = user
    @year = year
  end

  def call
    progress = calculate_progress
    ServiceResult.success(progress)
  rescue StandardError => e
    ServiceResult.failure(e.message)
  end

  private

  attr_reader :user, :year

  def calculate_progress
    total_movies = Movie.for_year(year).count
    return 0 if total_movies.zero?

    watched_movies = user.watched_movies_count_for_year(year)
    ((watched_movies.to_f / total_movies) * 100).round(1)
  end
end
