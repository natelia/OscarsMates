class MatesReviewsQuery
  def initialize(user, year, limit: 5)
    @user = user
    @year = year
    @limit = limit
  end

  def results
    Review.joins(movie: :nominations)
          .where(user: @user.following, nominations: { year: @year })
          .order(created_at: :desc)
          .limit(@limit)
          .includes(:user, :movie)
  end
end
