class ListCategoryQuery
  def initialize(params)
    @query = params[:query]
  end

  def results
    if @query.blank?
      Category.all
    else
      Category.where('name LIKE ?', "%#{@query}%")
    end
  end
end
