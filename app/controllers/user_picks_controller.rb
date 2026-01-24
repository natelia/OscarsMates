class UserPicksController < ApplicationController
  before_action :require_signin_json
  before_action :check_picking_allowed, only: %i[create destroy]

  def create
    @user_pick = current_user.user_picks.find_or_initialize_by(
      category_id: params[:category_id],
      year: params[:year]
    )

    @user_pick.movie_id = params[:movie_id]

    if @user_pick.save
      render json: { success: true, movie_title: @user_pick.movie.title }
    else
      render json: { success: false, errors: @user_pick.errors.full_messages }, status: :unprocessable_content
    end
  end

  def destroy
    @user_pick = current_user.user_picks.find_by(
      category_id: params[:id],
      year: params[:year]
    )

    if @user_pick&.destroy
      render json: { success: true }
    else
      render json: { success: false, errors: ['Pick not found'] }, status: :not_found
    end
  end

  private

  def require_signin_json
    return if current_user

    render json: { success: false, errors: ['Please sign in first'] }, status: :unauthorized
  end

  def check_picking_allowed
    # Allow picking until the ceremony date
    ceremony_date = Date.new(params[:year].to_i, 3, 15)
    return unless Time.zone.today > ceremony_date

    render json: { success: false, errors: ['Picking is closed after the ceremony'] }, status: :forbidden
  end
end
