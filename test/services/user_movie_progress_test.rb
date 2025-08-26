require "test_helper"

class UserMovieProgressTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(name: "example", email: "test@example.com", password: "password")
    @movie1 = Movie.create!(
      title: "Avatar",
      english_title: "Test1",
      where_to_watch: "Cinema",
      runtime: 140,
      rating: 9,
      url: "http://example.com",
      picture_url: "http://example.com/img.jpg"
    )
    @movie2 = Movie.create!(
      title: "Star Trek",
      english_title: "Test2",
      where_to_watch: "Cinema",
      runtime: 200,
      rating: 3,
      url: "http://example.com",
      picture_url: "http://example.com/img.jpg"
    )
    @review1 = Review.create!(user: @user, movie: @movie1, stars: 6, watched_on: Date.today)
    @review2 = Review.create!(user: @user, movie: @movie2, stars: 9, watched_on: Date.today)
  end

  def test_when_user_is_nil
    user = nil
    result = UserMovieProgress.new([@movie1, @movie2], user).call
    assert_equal({}, {})
  end

  def test_hash_action
    result = UserMovieProgress.new([@movie1, @movie2], @user).call
    assert result.is_a?(Hash)
    assert result.key?(@movie1.id)
    assert_equal @review1.id, result[@movie1.id].id
    assert_equal 2, result.keys.size
  end
end