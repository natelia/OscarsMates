# ApplicationController is the base class for all controllers in the application.
class ApplicationController < ActionController::Base
  include Pagy::Backend
  include ErrorHandling

  before_action :set_current_year

  helper_method :current_year, :available_years, :default_year

  private

  def set_current_year
    @current_year = params[:year]&.to_i if params[:year].present?
    # Store in session for persistence across non-year-scoped pages
    session[:selected_year] = @current_year if @current_year.present?
    # Use session year as fallback
    @current_year ||= session[:selected_year]&.to_i if session[:selected_year].present?
  end

  attr_reader :current_year

  def default_year
    @default_year ||= Nomination.available_years.first || 2025
  end

  def available_years
    @available_years ||= Nomination.available_years
  end

  def require_year
    return if current_year.present?

    redirect_to movies_path(year: default_year), alert: 'Please select a year first'
  end

  def require_signin
    return if current_user

    session[:intended_url] = request.url
    redirect_to new_session_url, alert: 'Please sign in first!'
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) || User.find_by(id: cookies.signed[:user_id])
  end

  helper_method :current_user

  def current_user?(user)
    current_user == user
  end

  helper_method :current_user?

  def require_admin
    return if current_user_admin?

    redirect_to root_url, alert: 'Unauthorized access!'
  end

  def current_user_admin?
    # Safe navigation prevents NoMethodError when current_user is nil
    current_user&.admin?
  end

  helper_method :current_user_admin?
end
