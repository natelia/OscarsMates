class MatesReviewsQuery
  def initialize(user, year, limit: 5, page: 1)
    @user = user
    @year = year
    @limit = limit
    @page = page || 1
  end

  def results
    reviews = Review.joins(movie: :nominations)
                    .where(user: @user.following, nominations: { oscar_year_id: @year })
                    .distinct
                    .order(created_at: :desc)

    if @limit
      offset = (@page - 1) * @limit
      reviews = reviews.limit(@limit).offset(offset)
    end

    reviews.includes(:user, :movie)
  end
end
