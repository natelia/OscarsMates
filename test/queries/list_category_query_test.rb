require "test_helper"

class ListCategoryQueryTest < ActiveSupport::TestCase
  def setup
    @category = create(:category)
    @movie = create(:movie)
    # Create nomination so category appears in year-scoped results
    create(:nomination, movie: @movie, category: @category, year: 2025)
  end

  def test_no_query
    params = {}
    results = ListCategoryQuery.new(params, 2025).results

    assert_includes results, @category
  end

  def test_with_query
    params = { query: @category.name }
    results = ListCategoryQuery.new(params, 2025).results

    assert_includes results, @category
  end
end
