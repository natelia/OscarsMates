class CategoriesController < ApplicationController
  before_action :require_admin, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  def index
    @categories = params[:query].present? ? Category.where('name LIKE ?', "%#{params[:query]}%") : Category.all
  end

  def show
    @category = Category.find(params[:id])
    @movies = @category.movies.includes(:reviews)
    @user_reviews = current_user ? current_user.reviews.index_by(&:movie_id) : {}
    
    # Handle unwatched action
    if params[:unwatched] && current_user
      movie = Movie.find(params[:unwatched])
      review = current_user.reviews.find_by(movie_id: movie.id)
      review&.update(watched: false)
      redirect_to category_path(@category), notice: "#{movie.title} marked as unwatched"
      return
    end
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to @category, notice: 'Category was successfully created'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @category.update(category_params)
      redirect_to @category, notice: 'Category was successfully updated'
    else
      render :edit
    end
  end

  def destroy
    @category.destroy
    redirect_to categories_url, notice: 'Category was successfully destroyed'
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
