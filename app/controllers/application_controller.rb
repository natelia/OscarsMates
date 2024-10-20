# ApplicationController is the base class for all controllers in the application.
class ApplicationController < ActionController::Base
  before_action :store_intended_url, only: [:require_signin]

  private

  # Redirects to the sign-in page if the user is not signed in.
  def require_signin
    unless current_user
      redirect_to new_session_url, alert: 'Please sign in first!'
    end
  end

  # Returns the currently signed-in user, if any.
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  # Checks if the given user is the current user.
  def current_user?(user)
    current_user == user
  end
  helper_method :current_user?

  # Redirects to the root path if the current user is not an admin.
  def require_admin
    return if current_user_admin?

    redirect_to root_url, alert: 'Unauthorized access!'
  end

  # Checks if the current user is an admin.
  def current_user_admin?
    current_user&.admin?
  end
  helper_method :current_user_admin?

  # Stores the URL that the user was trying to access.
  def store_intended_url
    session[:intended_url] = request.url
  end
end
