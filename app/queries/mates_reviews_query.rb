class MatesReviewsQuery
  def initialize(user, limit: 5)
    @user = user
    @limit = limit
  end

  def results
    Review.where(user: @user.following)
                          .order(created_at: :desc)
                          .limit(@limit)
                          .includes(:user, :movie)
  end
end
