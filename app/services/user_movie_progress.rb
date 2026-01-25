class UserMovieProgress
  def initialize(movies, user)
    @movies = movies
    @user = user
  end

  def call
    return {} unless @user

    movie_ids = @movies.map(&:id)
    reviews = @user.reviews.where(movie_id: movie_ids)
    review_pairs = reviews.map do |review|
      [review.movie.id, review]
    end
    review_pairs.to_h
  end
end
