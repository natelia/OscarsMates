class UserProgressService
  def initialize(user, year)
    @user = user
    @year = year
  end

  def progress
    total_movies = Movie.for_year(@year).count
    watched_movies = @user.watched_movies_count_for_year(@year)
    return 0 if total_movies.zero?

    ((watched_movies.to_f / total_movies) * 100).round(1)
  end
end
