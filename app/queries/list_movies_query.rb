class ListMoviesQuery
attr_reader :query, :filter, :current_user, :sort_by

  def initialize(query, filter, current_user, sort_by)
    @query = query
    @filter = filter
    @current_user = current_user
    @sort_by = sort_by
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
    case sort_by
    when 'duration'
      @results = @results.order(runtime: :desc)
    when 'watched_by_mates'
      mate_ids = current_user.following.pluck(:id)
      @results = @results.joins(:reviews)
                           .where(reviews: { user_id: mate_ids })
                           .group('movies.id')
                           .order('COUNT(reviews.id) DESC')
    when 'most_nominated'
      @results = @results.joins(:categories)
            .group('movies.id')
            .order('COUNT(categories.id) DESC')
    else
      @results = @results.order(:title)
    end
  end

  def filter_movies
    return @results unless current_user && filter == "unwatched"

    reviewed_movie_ids = current_user.reviews.pluck(:movie_id)
    @results = @results.where.not(id: reviewed_movie_ids)
  end
end
