class UserMovieProgress
  def initialize(movies, user)
    @movies = movies
    @user = user
  end

  def call
    return {} unless @user

    reviews = @user.reviews.where(movie: @movies)
    review_pairs = reviews.map do |review|
      [review.movie.id, review]
    end
    review_pairs.to_h
  end
end
