require 'test_helper'

class MovieTest < ActiveSupport::TestCase
  test 'is invalid if rating is out of range' do
    [-3, 13].each do |bad_ratiing|
      movie = build(:movie, rating: bad_ratiing)

      assert_not movie.valid?

      if bad_ratiing.negative?
        assert_includes movie.errors[:rating], 'must be greater than or equal to 0'
      else
        assert_includes movie.errors[:rating], 'must be less than or equal to 10'
      end
    end
  end

  test 'is invalid if title is not unique' do
    movie = create(:movie)
    movie1 = build(:movie, title: movie.title)

    assert_not movie1.valid?
    assert_includes movie1.errors[:title], 'has already been taken'
  end

  test 'is invalid if runtime is float' do
    movie = build(:movie, runtime: 121.123)
    assert_not movie.valid?
    assert_includes movie.errors[:runtime], 'must be an integer'
  end

  test 'is invalid without required attributes' do
    [:title, :english_title, :where_to_watch, :runtime, :rating, :url, :picture_url].each do |attr|
      movie = build(:movie)
      movie[attr] = nil
      assert_not movie.valid?, "#{attr} should not be valid when nil"
      assert_includes movie.errors[attr], "can't be blank"
    end
  end
end
