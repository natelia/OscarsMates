require 'test_helper'

class MoviesHelperTest < ActiveSupport::TestCase
  include MoviesHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::NumberHelper 

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

    user = User.first
    review = Review.create!(
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
end
