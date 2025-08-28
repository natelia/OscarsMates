require 'test_helper'

class MovieTest < ActiveSupport::TestCase
  test 'is invalid if rating is out of range' do
    [-3, 13].each do |bad_ratiing|
      movie = Movie.new(
        title: 'Inception',
        english_title: 'English Title',
        where_to_watch: 'Cinema',
        runtime: 120,
        rating: bad_ratiing,
        url: 'http://example.com',
        picture_url: 'http://example.com/img.jpg'
      )
      assert_not movie.valid?

      if bad_ratiing.negative?
        assert_includes movie.errors[:rating], 'must be greater than or equal to 0'
      else
        assert_includes movie.errors[:rating], 'must be less than or equal to 10'
      end
    end
  end

  test 'is invalid if title is not unique' do
    movie = Movie.create(
      title: 'Inception',
      english_title: 'English Title',
      where_to_watch: 'Cinema',
      runtime: 120,
      rating: 8,
      url: 'http://example.com',
      picture_url: 'http://example.com/img.jpg'
    )

    movie1 = Movie.new(
      title: 'Inception',
      english_title: 'English Title1',
      where_to_watch: 'Cinema1',
      runtime: 121,
      rating: 7,
      url: 'http://example.com',
      picture_url: 'http://example.com/img.jpg'
    )
    assert_not movie1.valid?
    assert_includes movie1.errors[:title], 'has already been taken'
  end

  test 'is invalid if runtime is float' do
    movie = Movie.new(
      title: 'Inception',
      english_title: 'English Title',
      where_to_watch: 'Cinema',
      runtime: 121.5,
      rating: 7,
      url: 'http://example.com',
      picture_url: 'http://example.com/img.jpg'
    )
    assert_not movie.valid?
    assert_includes movie.errors[:runtime], 'must be an integer'
  end

  test 'is invalid without required attributes' do
    [:title, :english_title, :where_to_watch, :runtime, :rating, :url, :picture_url].each do |attr|
      movie = Movie.new(
        title: 'Inception',
        english_title: 'English Title',
        where_to_watch: 'Cinema',
        runtime: 121.5,
        rating: 7,
        url: 'http://example.com',
        picture_url: 'http://example.com/img.jpg'
      )
      movie[attr] = nil
      assert_not movie.valid?, "#{attr} should not be valid when nil"
      assert_includes movie.errors[attr], "can't be blank"
    end
  end
end
