require 'test_helper'

class MovieTest < ActiveSupport::TestCase
  test "is invalid without title" do
  movie = Movie.new(
    title: nil,
    english_title: "English Title",
    where_to_watch: "Cinema",
    runtime: 120,
    rating: 8,
    url: "http://example.com",
    picture_url: "http://example.com/img.jpg"
  )
  assert_not movie.valid?
  assert_includes movie.errors[:title], "can't be blank"
  end
end
