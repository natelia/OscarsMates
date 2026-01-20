# frozen_string_literal: true

# Calculates detailed statistics for a user and their mates
class UserStatsService < ApplicationService
  def initialize(user:, year:)
    @user = user
    @year = year
  end

  def call
    stats = {
      user_stats: build_user_stats,
      mates_stats: build_mates_stats
    }
    ServiceResult.success(stats)
  rescue StandardError => e
    ServiceResult.failure(e.message)
  end

  private

  attr_reader :user, :year

  def build_user_stats
    {
      total_movies_watched: user.watched_movies_count_for_year(year),
      total_minutes_watched: total_minutes_watched(user)
    }
  end

  def build_mates_stats
    mates = user.following
    all_users = mates + [user]

    stats = all_users.map do |u|
      {
        name: u.name,
        total_movies_watched: u.watched_movies_count_for_year(year),
        total_minutes_watched: total_minutes_watched(u),
        daily_minutes_watched: user_daily_minutes_watched(u)
      }
    end

    process_mates_minutes_watched(stats)
  end

  def total_minutes_watched(target_user)
    target_user.reviews_for_year(year).joins(:movie).sum('movies.runtime')
  end

  def user_daily_minutes_watched(target_user)
    daily_minutes = target_user.reviews_for_year(year)
                               .joins(:movie)
                               .group('DATE(reviews.watched_on)')
                               .sum('movies.runtime')
                               .transform_keys(&:to_date)

    cumulative_sum = 0
    daily_minutes.sort.to_h.transform_values do |minutes|
      cumulative_sum += minutes
    end
  end

  def process_mates_minutes_watched(stats)
    return [] if stats.blank?

    all_dates = stats.flat_map { |mate| mate[:daily_minutes_watched].keys }.uniq
    return [] if all_dates.empty?

    date_range = (all_dates.min..all_dates.max).to_a

    stats.flat_map do |mate|
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
end
