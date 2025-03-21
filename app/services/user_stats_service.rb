class UserStatsService
  def initialize(user)
    @user = user
  end

  def user_stats
    {
      total_movies_watched: @user.reviews.count,
      total_minutes_watched: total_minutes_watched(@user)
    }
  end

  def mates_stats
    mates = @user.following
    all_users = mates + [@user]

    stats = all_users.map do |user|
      {
        name: user.name,
        total_movies_watched: user.reviews.count,
        total_minutes_watched: total_minutes_watched(user),
        daily_minutes_watched: user_daily_minutes_watched(user)
      }
    end
    
    # Add logging
    Rails.logger.info "Processed mates stats: #{stats.inspect}"
    
    process_mates_minutes_watched(stats)
  end

  private

  def total_minutes_watched(user)
    user.reviews.joins(:movie).sum('movies.runtime')
  end

  def user_daily_minutes_watched(user)
    daily_minutes = user.reviews
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
