class ListCategoryQuery
  def initialize(params, year)
    @query = params[:query]
    @year = year
  end

  def results
    categories = if @query.blank?
                   Category.all
                 else
                   Category.where('name LIKE ?', "%#{@query}%")
                 end

    # Only return categories that have nominations in the selected year
    categories.for_year(@year)
  end
end
