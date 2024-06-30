# SessionsController manages user sessions, allowing users to log in and log out.
class SessionsController < ApplicationController
  def new; end

  def create
    user = find_user_and_authenticate

    if user
      handle_successful_authentication(user)
    else
      handle_failed_authentication
    end
  end

  def find_user_and_authenticate
    User.find_by(email: params[:email])&.authenticate(params[:password])
  end

  def handle_successful_authentication(user)
    session[:user_id] = user.id
    redirect_to (session[:intended_url] || user),
                notice: "Welcome back, #{user.name}!"
    session[:intended_url] = nil
  end

  def handle_failed_authentication
    flash.now[:alert] = 'Invalid email/password combination!'
    render :new, status: :unprocessable_entity
  end

  def destroy
    session[:user_id] = nil
    redirect_to movies_url, status: :see_other,
                            notice: "You're now signed out!"
  end
end
