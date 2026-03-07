# rubocop:disable Metrics/ClassLength
class ListMoviesQuery
  attr_reader :query, :user, :sort_by, :filter_by, :category_id, :year

  def initialize(params, user, year)
    @query = params[:query]
    @filter_by = params[:filter_by]
    @sort_by = params[:sort_by]
    @category_id = params[:category_id]
    @user = user
    @year = year
  end

  def results
    prepare_collection

    search_movies if query.present?
    filter_by_category if category_id.present?
    apply_filters
    sort_movies

    @results
  end

  private

  def prepare_collection
    @results = Movie.for_year(year)
  end

  def search_movies
    sanitized = ActiveRecord::Base.sanitize_sql_like(query)
    query_term = "%#{sanitized}%"
    @results = @results.where(
      "title LIKE ? ESCAPE '\\' OR english_title LIKE ? ESCAPE '\\'",
      query_term,
      query_term
    )
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
    @results = @results.where.not(id: rated_movie_ids)
  end

  def filter_watched
    @results = @results.where(id: rated_movie_ids)
  end

  def filter_by_category
    @results = @results
               .joins(:nominations)
               .where(nominations: { category_id: category_id, year: year })
  end

  def rated_movie_ids
    @rated_movie_ids ||= user.reviews.where.not(stars: nil).select(:movie_id)
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
    when 'most_watched_by_mates'
      sort_by_most_watched_by_mates
    when 'most_nominated'
      sort_by_nominations
    else
      @results = @results.order(:title)
    end
  end

  def sort_by_user_rating
    return @results = @results.order(:title) unless user

    # Show all movies, with rated ones first sorted by rating, then unrated ones last
    user_reviews = Review
                   .where(user_id: user.id)
                   .select('movie_id, stars')

    @results = @results
               .joins("LEFT JOIN (#{user_reviews.to_sql}) AS user_reviews ON movies.id = user_reviews.movie_id")
               .order(Arel.sql('user_reviews.stars DESC NULLS LAST, movies.title ASC'))
  end

  def sort_by_mates_watched
    return @results = @results.order(:title) unless user

    mate_ids = user.following.pluck(:id)
    return @results = @results.order(:title) if mate_ids.empty?

    mates_avg = Review.where(user_id: mate_ids).where.not(stars: nil)
                      .group(:movie_id).select('movie_id, AVG(stars) as avg_rating')

    @results = @results
               .joins("LEFT JOIN (#{mates_avg.to_sql}) AS mates_reviews ON movies.id = mates_reviews.movie_id")
               .order(Arel.sql('mates_reviews.avg_rating DESC NULLS LAST, movies.title ASC'))
  end

  def sort_by_most_watched_by_mates
    return @results = @results.order(:title) unless user

    mate_ids = user.following.pluck(:id)
    return @results = @results.order(:title) if mate_ids.empty?

    mates_count = Review.where(user_id: mate_ids).where.not(stars: nil)
                        .group(:movie_id).select('movie_id, COUNT(*) as watch_count')

    @results = @results
               .joins("LEFT JOIN (#{mates_count.to_sql}) AS mates_watches ON movies.id = mates_watches.movie_id")
               .select('movies.*, COALESCE(mates_watches.watch_count, 0) as mates_watch_count')
               .order(Arel.sql('mates_watches.watch_count DESC NULLS LAST, movies.title ASC'))
  end

  def sort_by_nominations
    nominations_count = Nomination.where(year: year)
                                  .group(:movie_id)
                                  .select('movie_id, COUNT(*) as nom_count')

    @results = @results
               .joins("LEFT JOIN (#{nominations_count.to_sql}) AS nom_counts ON movies.id = nom_counts.movie_id")
               .select('movies.*, COALESCE(nom_counts.nom_count, 0) as nominations_count')
               .order(Arel.sql('nom_counts.nom_count DESC NULLS LAST, movies.title ASC'))
  end
end
# rubocop:enable Metrics/ClassLength
