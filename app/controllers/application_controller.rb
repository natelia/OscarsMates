# ApplicationController is the base class for all controllers in the application.
class ApplicationController < ActionController::Base
  before_action :set_current_year

  helper_method :current_year, :available_years

  private

  def set_current_year
    @current_year = params[:year]&.to_i
  end

  def current_year
    @current_year
  end

  def available_years
    @available_years ||= Nomination.available_years
  end

  def require_year
    return if current_year.present?

    redirect_to root_path, alert: 'Please select a year first'
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
    current_user&.admin? # if current_user is nil, the safe navigation operator &. will prevent a NoMethodError and return nil instead
  end

  helper_method :current_user_admin?
end
