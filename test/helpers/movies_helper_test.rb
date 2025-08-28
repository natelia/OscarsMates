require 'test_helper'

class MoviesHelperTest < ActionView::TestCase
  def setup
    @movie_no_reviews = create(:movie, title: 'movie_no_review')
    @movie_with_reviews = create(:movie, title: 'movie_with_reviews')
    @user = create(:user)
    @review = create(:review, movie: @movie_with_reviews, user: @user, stars: 5)
  end

  def test_movie_no_reviews
    result = average_stars(@movie_no_reviews)
    assert_includes result, 'No reviews'
  end

  def test_movie_with_reviews
    result = average_stars(@movie_with_reviews)
    assert_includes result, '5.0 stars'
  end

  def test_watched_button
    result = watch_or_unwatch_button(@movie_no_reviews, nil)
    assert_includes result, 'Watched!'
  end

  def test_unwatched_button
    result = watch_or_unwatch_button(@movie_with_reviews, @review)
    assert_includes result, 'Unwatch!'
  end
end
