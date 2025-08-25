require 'test_helper'

class ListMoviesQueryTest < ActiveSupport::TestCase
  def setup
    Movie.destroy_all
    @user = User.create!(name: "Test", email: "test@example.com", password: "password")
    @movie1 = Movie.create!(
      title: "Star Wars",
      english_title: "Test1",
      where_to_watch: "Cinema",
      runtime: 100,
      rating: 5,
      url: "http://example.com",
      picture_url: "http://example.com/img.jpg"
    )

    @movie2 = Movie.create!(
      title: "Star Trek",
      english_title: "Test2",
      where_to_watch: "Cinema",
      runtime: 120,
      rating: 7,
      url: "http://example.com",
      picture_url: "http://example.com/img.jpg"
    )

    @movie3 = Movie.create!(
      title: "Avatar",
      english_title: "Test3",
      where_to_watch: "Cinema",
      runtime: 140,
      rating: 9,
      url: "http://example.com",
      picture_url: "http://example.com/img.jpg"
    )

    Review.create!(movie: @movie1, user: @user, stars: 5, watched_on: 12-12-2012)

  end

  def test_returns_all_movies
    query = ListMoviesQuery.new({}, @user)
    results = query.results

    titles = []
    results.each do |movie|
        titles << movie.title
    end
    assert_includes titles, "Star Wars"
    assert_includes titles, "Star Trek"
    assert_includes titles, "Avatar"
  end

  def test_returns_query_movies
    params = { query: "Star"}
    query = ListMoviesQuery.new(params, @user)
    results = query.results

    titles = []
    results.each do |movie|
        titles << movie.title
    end
    assert_includes titles, "Star Wars"
    assert_includes titles, "Star Trek"
    refute_includes titles, "Avatar"
  end

  def test_returns_sorted_movies
    params = {sort_by: "duration"}
    query = ListMoviesQuery.new(params, @user)
    results = query.results

    titles = []
    results.each do |movie|
        titles << movie.title
    end
    assert_equal "Avatar", titles[0]
    assert_equal "Star Trek", titles[1]
    assert_equal "Star Wars", titles[2]
  end

  def test_returns_filtered_movies
    params = {filter_by: "unwatched"}
    query = ListMoviesQuery.new(params, @user)
    results = query.results

    titles = []
    results.each do |movie|
        titles << movie.title
    end

    refute_includes titles, @movie1.title
    assert_includes titles, @movie2.title
    assert_includes titles, @movie3.title
  end

  def test_returns_alphabetically_sorted_movies
    params = {}
    query = ListMoviesQuery.new(params, @user)
    results = query.results

    titles = []
    results.each do |movie|
        titles << movie.title
    end
    expected_order = ["Avatar", "Star Trek", "Star Wars"]
    assert_equal expected_order, titles
  end 
end