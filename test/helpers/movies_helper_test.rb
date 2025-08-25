require 'test_helper'

class MoviesHelperTest < ActionView::TestCase
  include MoviesHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::NumberHelper 
  include ActionView::Helpers::UrlHelper
  include Rails.application.routes.url_helpers

  def setup
    @movie_no_reviews = Movie.create!(
      title: "No Reviews",
      english_title: "NR",
      where_to_watch: "Cinema",
      runtime: 90,
      rating: 0,
      url: "http://example.com",
      picture_url: "http://example.com/img.jpg"
    )

    @movie_with_reviews = Movie.create!(
      title: "With Reviews",
      english_title: "WR",
      where_to_watch: "Cinema",
      runtime: 90,
      rating: 3,
      url: "http://example.com",
      picture_url: "http://example.com/img.jpg"
    )

    user = User.first || User.create!(name: "Test", email: "test@example.com", password: "password")
    @review = Review.create!(
      movie: @movie_with_reviews,
      user: user,
      stars: 3,
      watched_on: Date.today
    )
  end

  def test_movie_no_reviews
    result = average_stars(@movie_no_reviews)
    assert_includes result, "No reviews"
  end

  def test_movie_with_reviews
    result = average_stars(@movie_with_reviews)
    assert_includes result, "3.0 stars"
  end

  def test_watched_button
    result = watch_or_unwatch_button(@movie_no_reviews, nil)
    assert_includes result, "Watched!"
  end

  def test_unwatched_button
    result = watch_or_unwatch_button(@movie_with_reviews, @review)
    assert_includes result, "Unwatch!"
  end
end
