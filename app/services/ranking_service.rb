# Provides ranking data for users based on their movie watching progress.
# Supports multiple metrics (films, minutes, nominations) and sorting modes.
#
# Modes:
# - goals: percentage = watched / total available (e.g., 4/16 films = 25%)
# - totals: percentage = watched / best user's watched (e.g., if top user has 4, you have 2 = 50%)
class RankingService
  attr_reader :year, :current_user, :metric, :mode, :scope

  VALID_METRICS = %i[films minutes nominations].freeze
  VALID_MODES = %i[goals totals].freeze
  VALID_SCOPES = %i[mates all].freeze

  def initialize(year:, current_user: nil, metric: :films, mode: :goals, scope: :mates)
    @year = year
    @current_user = current_user
    @metric = VALID_METRICS.include?(metric.to_sym) ? metric.to_sym : :films
    @mode = VALID_MODES.include?(mode.to_sym) ? mode.to_sym : :goals
    @scope = VALID_SCOPES.include?(scope.to_sym) ? scope.to_sym : :mates
  end

  def ranked_users
    users = base_users

    # First pass: calculate raw watched counts for all users
    users_with_raw_stats = users.map { |u| [u, calculate_raw_stats(u)] }

    # Find max values for "totals" mode (the best user's counts)
    max_values = calculate_max_values(users_with_raw_stats)

    # Second pass: calculate percentages based on mode
    users_with_stats = users_with_raw_stats.map do |user, raw_stats|
      [user, calculate_percentages(raw_stats, max_values)]
    end

    # Sort and rank
    sorted = sort_users(users_with_stats)
    sorted.map.with_index(1) { |(user, stats), rank| { user: user, stats: stats, rank: rank } }
  end

  def totals
    @totals ||= {
      films: total_films,
      minutes: total_minutes,
      nominations: total_nominations
    }
  end

  private

  def base_users
    if scope == :mates && current_user
      current_user.following.to_a + [current_user]
    else
      User.all.to_a
    end
  end

  # Calculate raw watched counts without percentages
  def calculate_raw_stats(user)
    # Use User model's existing method (proven to work)
    films_count = user.watched_movies_count_for_year(year)

    # Get movie IDs from user's reviews for this year
    movie_ids = user.reviews_for_year(year).select(:movie_id).distinct.pluck(:movie_id)

    minutes_sum = movie_ids.empty? ? 0 : Movie.where(id: movie_ids).sum(:runtime)
    nominations_count = movie_ids.empty? ? 0 : Nomination.where(oscar_year_id: year, movie_id: movie_ids).count

    {
      films: { watched: films_count },
      minutes: { watched: minutes_sum },
      nominations: { watched: nominations_count }
    }
  end

  # Find the maximum watched value for each metric across all users
  def calculate_max_values(users_with_raw_stats)
    {
      films: users_with_raw_stats.map { |_, s| s[:films][:watched] }.max || 0,
      minutes: users_with_raw_stats.map { |_, s| s[:minutes][:watched] }.max || 0,
      nominations: users_with_raw_stats.map { |_, s| s[:nominations][:watched] }.max || 0
    }
  end

  # Calculate percentages based on mode
  # - goals: compared to total available
  # - totals: compared to best user
  def calculate_percentages(raw_stats, max_values)
    {
      films: build_stat(
        raw_stats[:films][:watched],
        total_films,
        max_values[:films]
      ),
      minutes: build_stat(
        raw_stats[:minutes][:watched],
        total_minutes,
        max_values[:minutes]
      ),
      nominations: build_stat(
        raw_stats[:nominations][:watched],
        total_nominations,
        max_values[:nominations]
      )
    }
  end

  def build_stat(watched, total, max_watched)
    denominator = mode == :goals ? total : max_watched
    {
      watched: watched,
      total: denominator, # Show the actual denominator based on mode
      percentage: safe_percentage(watched, denominator)
    }
  end

  def sort_users(users_with_stats)
    users_with_stats.sort_by do |_user, stats|
      # Always sort by percentage (which is calculated differently based on mode)
      -stats[metric][:percentage]
    end
  end

  def total_films
    @total_films ||= Movie.for_year(year).count
  end

  def total_minutes
    @total_minutes ||= Movie.for_year(year).sum(:runtime)
  end

  def total_nominations
    @total_nominations ||= Nomination.where(oscar_year_id: year).count
  end

  def safe_percentage(watched, total)
    return 0.0 if total.zero?

    ((watched.to_f / total) * 100).round(1)
  end
end
