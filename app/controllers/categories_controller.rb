class CategoriesController < ApplicationController
  before_action :require_year
  before_action :require_admin, only: %i[new create edit update destroy]
  before_action :set_category, only: %i[show edit update destroy]

  def index
    @categories = ListCategoryQuery.new(params, current_year).results
    # Preload movies for each category to display on the index page
    @categories = @categories.includes(movies: %i[reviews nominations])
    @user_reviews = current_user ? current_user.reviews.index_by(&:movie_id) : {}
    @user_picks = current_user ? current_user.user_picks.where(year: current_year).index_by(&:category_id) : {}

    # Get pick counts for all movies
    @pick_counts = UserPick.where(year: current_year)
                           .group(:movie_id)
                           .count

    # Summary statistics
    @total_nominees = Movie.joins(:nominations).where(nominations: { year: current_year }).distinct.count
    @ceremony_date = Date.new(current_year, 3, 15)
    @days_until_ceremony = (@ceremony_date - Time.zone.today).to_i
    @categories_count = @categories.count
    @picking_allowed = Time.zone.today <= @ceremony_date
  end

  def show
    @category = Category.find(params[:id])
    @movies = @category.movies.for_year(current_year).includes(:reviews)
    @user_reviews = current_user ? current_user.reviews.index_by(&:movie_id) : {}

    # Handle unwatched action
    return unless params[:unwatched] && current_user

    movie = Movie.find(params[:unwatched])
    review = current_user.reviews.find_by(movie_id: movie.id)
    review&.update(watched: false)
    redirect_to category_path(@category, year: current_year), notice: "#{movie.title} marked as unwatched"
    nil
  end

  def new
    @category = Category.new
  end

  def edit; end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to category_path(@category, year: current_year), notice: 'Category was successfully created'
    else
      render :new
    end
  end

  def update
    if @category.update(category_params)
      redirect_to category_path(@category, year: current_year), notice: 'Category was successfully updated'
    else
      render :edit
    end
  end

  def destroy
    @category.destroy
    redirect_to categories_path(year: current_year), notice: 'Category was successfully destroyed'
  end

  private

  # Sets the category instance variable for specific actions.
  def set_category
    @category = Category.find(params[:id])
  end

  # Strong parameters for category creation and updates.
  def category_params
    params.require(:category).permit(:name)
  end
end
