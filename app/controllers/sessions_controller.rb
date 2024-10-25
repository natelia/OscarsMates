# SessionsController manages user sessions, allowing users to log in and log out.
class SessionsController < ApplicationController
  def new; end

  def create
    user = authenticate_user

    user ? successful_authentication(user) : failed_authentication
  end

  def destroy
    session[:user_id] = nil
    redirect_to movies_url, status: :see_other,
                            notice: "You're now signed out!"
  end

  private

  def authenticate_user
    User.find_by(email: params[:email])&.authenticate(params[:password])
  end

  def successful_authentication(user)
    session[:user_id] = user.id
    redirect_to (session[:intended_url] || user),
                notice: "Welcome back, #{user.name}!"
  end

  def failed_authentication
    flash.now[:alert] = 'Invalid email/password combination!'
    render :new, status: :unprocessable_entity
  end
end
