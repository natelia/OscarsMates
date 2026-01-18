class MovieSortingService
  def initialize(movies, sort_by, user)
    @movies = movies
    @sort_by = sort_by
    @user = user
  end

  def call
    case @sort_by
    when 'duration'
      @movies.order(runtime: :desc)
    when 'watched_by_mates'
      mate_ids = @user.following.pluck(:id)
      @movies.joins(:reviews)
             .where(reviews: { user_id: mate_ids })
             .group('movies.id')
             .order('COUNT(reviews.id) DESC')
    when 'most_nominated'
      @movies.joins(:categories)
             .group('movies.id')
             .order('COUNT(categories.id) DESC')
    else
      @movies.order(:title)
    end
  end
end
