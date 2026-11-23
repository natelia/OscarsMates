# Provides ranking data for users based on their movie watching progress.
# Supports multiple metrics (films, minutes, nominations) and sorting modes.
#
# Modes:
# - goals: percentage = watched / total available (e.g., 4/16 films = 25%)
# - totals: percentage = watched / best user's watched (e.g., if top user has 4, you have 2 = 50%)
#
# Watched stats for all ranked users are computed with three grouped queries
# instead of one set of queries per user.
# rubocop:disable Metrics/ClassLength
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
    raw_stats_by_user_id = batched_raw_stats(users)

    # Find max values for "totals" mode (the best user's counts)
    max_values = calculate_max_values(users, raw_stats_by_user_id)

    # Second pass: calculate percentages based on mode
    users_with_stats = users.map do |user|
      [user, calculate_percentages(raw_stats_by_user_id[user.id], max_values)]
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

  # Calculate raw watched counts for all users with three grouped queries:
  # distinct (user, movie) watch pairs, movie runtimes, and nomination counts.
  def batched_raw_stats(users)
    movies_by_user = watch_pairs_by_user
    runtime_by_movie = runtime_by_movie_for(movies_by_user.values.flatten.uniq)
    nominations_by_movie = nominations_by_movie_for

    users.index_by(&:id).transform_values do |user|
      raw_stats_for(movies_by_user[user.id], runtime_by_movie, nominations_by_movie)
    end
  end

  def watch_pairs_by_user
    watch_pairs = Review.where.not(stars: nil)
                        .joins(movie: :nominations)
                        .where(nominations: { year: year })
                        .distinct
                        .pluck(:user_id, :movie_id)

    watch_pairs.each_with_object(Hash.new { |hash, key| hash[key] = [] }) do |(user_id, movie_id), hash|
      hash[user_id] << movie_id
    end
  end

  def runtime_by_movie_for(movie_ids)
    Movie.where(id: movie_ids).pluck(:id, :runtime).to_h
  end

  def nominations_by_movie_for
    Nomination.where(year: year).group(:movie_id).count
  end

  def raw_stats_for(movie_ids, runtime_by_movie, nominations_by_movie)
    return { films: 0, minutes: 0, nominations: 0 } if movie_ids.empty?

    {
      films: movie_ids.length,
      minutes: movie_ids.sum { |movie_id| runtime_by_movie[movie_id].to_i },
      nominations: movie_ids.sum { |movie_id| nominations_by_movie[movie_id].to_i }
    }
  end

  # Find the maximum watched value for each metric across all users
  def calculate_max_values(users, raw_stats_by_user_id)
    {
      films: users.map { |user| raw_stats_by_user_id[user.id][:films] }.max || 0,
      minutes: users.map { |user| raw_stats_by_user_id[user.id][:minutes] }.max || 0,
      nominations: users.map { |user| raw_stats_by_user_id[user.id][:nominations] }.max || 0
    }
  end

  # Calculate percentages based on mode
  # - goals: compared to total available
  # - totals: compared to best user
  def calculate_percentages(raw_stats, max_values)
    {
      films: build_stat(
        raw_stats[:films],
        total_films,
        max_values[:films]
      ),
      minutes: build_stat(
        raw_stats[:minutes],
        total_minutes,
        max_values[:minutes]
      ),
      nominations: build_stat(
        raw_stats[:nominations],
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
    @total_nominations ||= Nomination.where(year: year).count
  end

  def safe_percentage(watched, total)
    return 0.0 if total.zero?

    ((watched.to_f / total) * 100).round(1)
  end
end
# rubocop:enable Metrics/ClassLength
