# ApplicationController is the base class for all controllers in the application.
class ApplicationController < ActionController::Base
  private

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
