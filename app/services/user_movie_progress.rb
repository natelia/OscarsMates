class UserMovieProgress
  def initialize(movies, user)
    @movies = movies
    @user = user
  end

  def call
    reviews_hash = {}
    if @user
      reviews = @user.reviews.where(movie: @movies)
      reviews.each do |review|
        reviews_hash[review.movie_id] = review
      end
    end
    reviews_hash
  end
end