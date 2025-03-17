class MovieFilteringService

  def initialize(movies, user)
    @movies = movies
    @user = user
  end

  def filter_unwatched
    reviewed_movie_ids = @user.reviews.pluck(:movie_id)
    @movies.where.not(id: reviewed_movie_ids)
  end
end