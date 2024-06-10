class MoviesController < ApplicationController

  before_action :require_signin, except: [:index, :show]
  before_action :require_admin, except: [:index, :show]

  def index
    @movies = Movie.all
  end


  def show
    @movie = Movie.find(params[:id])
    @fans = @movie.fans
    if current_user
      @favorite = current_user.favorites.find_by(movie_id: @movie.id)
    end
  end

  def new 
    @movie = Movie.new
  end

  def create
    @movie = Movie.new(movie_params)

    if @movie.save
      redirect_to @movie, notice: 'Movie successfully created!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @movie = Movie.find(params[:id])
  end

  def update
    @movie = Movie.find(params[:id])
    if @movie.update(movie_params)
      redirect_to @movie, notice: 'Movie successfully updated!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    redirect_to root_path, status: :see_other, alert: 'Movie successfully deleted!'
  end

  private

  def movie_params
    params.require(:movie).permit(:title, :english_title, :where_to_watch, :runtime, :rating, :url, :picture_url)
  end

end
