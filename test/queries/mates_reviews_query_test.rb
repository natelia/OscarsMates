require 'test_helper'

class MatesReviewsQueryTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(name: "Test", email: "test@example.com", password: "password")
    6.times do |i|
      movie = Movie.create!(title: "Avatar#{i}",
        english_title: "Test5",
        where_to_watch: "Cinema", runtime: 140, rating: 9, url: "http://example.com", picture_url: "http://example.com/img.jpg"
      )
      @review = Review.create!(watched_on: Date.today, stars: 5, user: @user, movie: movie)
    end
  end

  def test_returns_empty_when_user_follows_no_one
    results = MatesReviewsQuery.new(@user).results
    assert_equal [], results
  end

  def test_bigger_number_of_limit
    followed_user = User.create!(name: 'Followed', email: 'followed@example.com', password: 'password')
    @user.following << followed_user

    6.times do |n|
      movie = Movie.create!(title: "Test#{n}",
        english_title: "Test",
        where_to_watch: "Cinema", runtime: 140, rating: 9, url: "http://example.com", picture_url: "http://example.com/img.jpg"
      )
      @review = Review.create!(watched_on: Date.today, stars: 5, user: followed_user, movie: movie)
    end

    results = MatesReviewsQuery.new(@user, limit: 5).results
    assert_equal 5, results.count
  end
end
