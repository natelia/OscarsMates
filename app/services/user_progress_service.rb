class UserProgressService

  def initialize(user)
    @user = user
  end

  def progress
    total_movies = Movie.count
    watched_movies = @user.reviews.count
    return 0 if total_movies.zero?

    (watched_movies.to_f / total_movies) * 100
  end
end