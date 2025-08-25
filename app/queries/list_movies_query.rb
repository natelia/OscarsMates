class ListMoviesQuery
attr_reader :query, :user, :sort_by

  def initialize(params, user)
    @query = params[:query]
    @only_unwatched = user && params[:filter_by] == 'unwatched'
    @sort_by = params[:sort_by]
    @user = user
  end

  def results
    prepare_collection

    search_movies if query.present?
    sort_movies
    filter_movies if only_unwatched?
    @results
  end

  private
  
  def only_unwatched?
    @only_unwatched
  end

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
      mate_ids = user.following.pluck(:id)
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
    reviewed_movie_ids = user.reviews.select(:movie_id)
    @results = @results.where.not(id: reviewed_movie_ids)
  end
end
