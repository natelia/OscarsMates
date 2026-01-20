class UserMovieProgress
  def initialize(movies, user)
    @movies = movies
    @user = user
  end

  def call
    return {} unless @user

    reviews = @user.reviews.where(movie: @movies)
    reviews.index_by(&:movie_id)
  end
end
