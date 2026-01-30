class CategoriesController < ApplicationController
  before_action :require_year
  before_action :require_admin, only: %i[new create edit update destroy]
  before_action :set_category, only: %i[show edit update destroy]

  # rubocop:disable Metrics/AbcSize
  def index
    @categories = ListCategoryQuery.new(params, current_year).results
    @user_reviews = current_user ? current_user.reviews.index_by(&:movie_id) : {}
    @user_picks = current_user ? current_user.user_picks.where(year: current_year).index_by(&:category_id) : {}

    # Preload movies by category for the current year to prevent N+1 queries
    # Keep duplicates - a movie with multiple nominations in the same category should appear multiple times
    nominations = Nomination.where(year: current_year, category_id: @categories.select(:id))
                            .includes(movie: :reviews)
    @category_movies = nominations.group_by(&:category_id).transform_values do |noms|
      noms.map(&:movie)
    end

    # Get pick counts per category/movie from users the current user follows
    @pick_counts = if current_user
                     UserPick.where(year: current_year, user_id: current_user.following.select(:id))
                             .group(:category_id, :movie_id)
                             .count
                   else
                     {}
                   end

    # Summary statistics
    @total_nominees = Movie.joins(:nominations).where(nominations: { year: current_year }).distinct.count
    @ceremony_date = Date.new(current_year, 3, 15)
    @days_until_ceremony = (@ceremony_date - Time.zone.today).to_i
    @categories_count = @categories.count - @user_picks.count
  end
  # rubocop:enable Metrics/AbcSize

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
