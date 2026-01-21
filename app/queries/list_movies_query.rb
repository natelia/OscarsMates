class ListMoviesQuery
  attr_reader :query, :user, :sort_by, :filter_by, :year

  def initialize(params, user, year)
    @query = params[:query]
    @filter_by = params[:filter_by]
    @sort_by = params[:sort_by]
    @user = user
    @year = year
  end

  def results
    prepare_collection

    search_movies if query.present?
    apply_filters
    sort_movies

    @results
  end

  private

  def prepare_collection
    @results = Movie.for_year(year)
  end

  def search_movies
    @results = @results.where('title LIKE ?', "%#{query.downcase}%")
  end

  def apply_filters
    return unless user && filter_by.present?

    case filter_by
    when 'unwatched'
      filter_unwatched
    when 'watched'
      filter_watched
    end
  end

  def filter_unwatched
    reviewed_movie_ids = user.reviews.select(:movie_id)
    @results = @results.where.not(id: reviewed_movie_ids)
  end

  def filter_watched
    reviewed_movie_ids = user.reviews.select(:movie_id)
    @results = @results.where(id: reviewed_movie_ids)
  end

  def sort_movies
    case sort_by
    when 'duration'
      @results = @results.order(runtime: :desc)
    when 'shortest'
      @results = @results.order(runtime: :asc)
    when 'imdb_rating'
      @results = @results.order(rating: :desc)
    when 'my_rating'
      sort_by_user_rating
    when 'watched_by_mates'
      sort_by_mates_watched
    when 'most_nominated'
      sort_by_nominations
    else
      @results = @results.order(:title)
    end
  end

  def sort_by_user_rating
    return @results = @results.order(:title) unless user

    # Only show movies the user has rated, sorted by their rating
    @results = @results
               .joins(:reviews)
               .where(reviews: { user_id: user.id })
               .order('reviews.stars DESC, movies.title ASC')
  end

  def sort_by_mates_watched
    return @results = @results.order(:title) unless user

    mate_ids = user.following.pluck(:id)
    return @results = @results.order(:title) if mate_ids.empty?

    # Subquery to get average rating from mates for each movie
    mates_avg = Review
                .where(user_id: mate_ids)
                .group(:movie_id)
                .select('movie_id, AVG(stars) as avg_rating')

    @results = @results
               .joins("LEFT JOIN (#{mates_avg.to_sql}) AS mates_reviews ON movies.id = mates_reviews.movie_id")
               .order(Arel.sql('mates_reviews.avg_rating DESC NULLS LAST, movies.title ASC'))
  end

  def sort_by_nominations
    @results = @results
               .joins(:categories)
               .group('movies.id')
               .order('COUNT(categories.id) DESC')
  end
end
