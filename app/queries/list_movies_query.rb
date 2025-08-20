class ListMoviesQuery
attr_reader :query, :filter, :current_user

  def initialize(query, filter, current_user)
    @query = query
    @filter = filter
    @current_user = current_user
  end

  def results
    prepare_collection

    search_movies if query.present?
    sort_movies
    filter_movies if current_user && filter == 'unwatched'
    @results
  end

  private

  def prepare_collection
    @results = Movie.all
  end

  def search_movies
    @results = @results.where('title LIKE ?', "%#{query}%")
  end

  def sort_movies
    @results = @results.order(:title)
  end

  def filter_movies
    return @results unless current_user && filter == "unwatched"

    reviewed_movie_ids = current_user.reviews.pluck(:movie_id)
    @results = @results.where.not(id: reviewed_movie_ids)
  end
end
