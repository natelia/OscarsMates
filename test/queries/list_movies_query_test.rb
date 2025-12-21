require 'test_helper'

class ListMoviesQueryTest < ActiveSupport::TestCase
  def setup
    Movie.destroy_all
    @user = create(:user)
    @category = create(:category)
    @movie1 = create(:movie, title: 'Star Wars', runtime: 100)
    @movie2 = create(:movie, title: 'Star Trek', runtime: 120)
    @movie3 = create(:movie, title: 'Avatar', runtime: 140)
    # Create nominations so movies appear in year-scoped results
    create(:nomination, movie: @movie1, category: @category, year: 2025)
    create(:nomination, movie: @movie2, category: @category, year: 2025)
    create(:nomination, movie: @movie3, category: @category, year: 2025)
    @review = create(:review, movie: @movie1, user: @user)
  end

  def test_returns_all_movies
    results = ListMoviesQuery.new({}, @user, 2025).results
    titles = results.map(&:title)

    ['Star Wars', 'Star Trek', 'Avatar'].each do |title|
      assert_includes titles, title
    end
  end

  def test_returns_query_movies
    params = { query: 'Star' }
    query = ListMoviesQuery.new(params, @user, 2025)
    results = query.results

    titles = results.map(&:title)

    assert_includes titles, 'Star Wars'
    assert_includes titles, 'Star Trek'
    refute_includes titles, 'Avatar'
  end

  def test_returns_sorted_movies
    params = {sort_by: 'duration' }
    query = ListMoviesQuery.new(params, @user, 2025)
    results = query.results

    titles = results.map(&:title)

    assert_equal 'Avatar', titles[0]
    assert_equal 'Star Trek', titles[1]
    assert_equal 'Star Wars', titles[2]
  end

  def test_returns_filtered_movies
    params = { filter_by: 'unwatched' }
    query = ListMoviesQuery.new(params, @user, 2025)
    results = query.results

    titles = results.map(&:title)

    refute_includes titles, @movie1.title
    assert_includes titles, @movie2.title
    assert_includes titles, @movie3.title
  end

  def test_returns_alphabetically_sorted_movies
    params = {}
    query = ListMoviesQuery.new(params, @user, 2025)
    results = query.results

    titles = results.map(&:title)

    expected_order = ['Avatar', 'Star Trek', 'Star Wars']
    assert_equal expected_order, titles
  end
end
