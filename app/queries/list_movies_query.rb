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
end
