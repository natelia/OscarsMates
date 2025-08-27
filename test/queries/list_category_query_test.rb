require "test_helper"

class ListCategoryQueryTest < ActiveSupport::TestCase
  def test_no_query
    params = {}
    results = ListCategoryQuery.new(params).results

    assert_equal Category.all, results
  end
end
