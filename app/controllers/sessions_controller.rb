# SessionsController manages user sessions, allowing users to log in and log out.
class SessionsController < ApplicationController
  def new; end

  def create
    user = authenticate_user

    if user
      session[:user_id] = user.id
      cookies.signed[:remember_me] = {
        value: "#{user.id}:#{user.session_token}",
        expires: 30.days.from_now,
        httponly: true,
        same_site: :lax
      }
      redirect_to root_path, notice: 'Logged in successfully!'
    else
      failed_authentication
    end
  end

  def destroy
    session[:user_id] = nil
    cookies.delete(:remember_me)
    redirect_to root_path, notice: 'Logged out successfully!'
  end

  private

  def authenticate_user
    User.find_by(email: params[:email])&.authenticate(params[:password])
  end

  def failed_authentication
    flash.now[:alert] = 'Invalid email/password combination!'
    render :new, status: :unprocessable_content
  end
end
