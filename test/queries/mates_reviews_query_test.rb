require 'test_helper'

class MatesReviewsQueryTest < ActiveSupport::TestCase
  def setup
    @user = create(:user)
    @category = create(:category)
    6.times do |i|
      movie = create(:movie, title: "Avatar#{i}")
      create(:nomination, movie: movie, category: @category, year: 2025)
      create(:review, watched_on: Date.today, stars: 5, user: @user, movie: movie)
    end
  end

  def test_returns_empty_when_user_follows_no_one
    results = MatesReviewsQuery.new(@user, 2025).results
    assert_equal [], results.to_a
  end

  def test_bigger_number_of_limit
    followed_user = create(:user, name: 'Followed', email: 'followed@example.com')
    @user.following << followed_user

    6.times do |n|
      movie = create(:movie, title: "Test#{n}")
      create(:nomination, movie: movie, category: @category, year: 2025)
      create(:review, watched_on: Date.today, stars: 5, user: followed_user, movie: movie)
    end

    results = MatesReviewsQuery.new(@user, 2025, limit: 5).results
    assert_equal 5, results.count
  end
end
