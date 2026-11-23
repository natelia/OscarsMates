# Manages the password reset flow: requesting a reset email and setting a new password.
class PasswordResetsController < ApplicationController
  before_action :set_user_from_token, only: %i[edit update]

  def new; end

  def edit; end

  def create
    user = User.find_by(email: params[:email])

    if user
      token = user.generate_token_for(:password_reset)
      UserMailer.password_reset(user, token).deliver_now
    end

    # Same response either way, so the form cannot be used to discover registered emails
    redirect_to signin_path, notice: 'If that email is registered, a password reset link is on its way.'
  end

  def update
    @user.password = params[:password]
    @user.password_confirmation = params[:password_confirmation]

    if @user.save
      # Reset tokens are dead after the password change; so are remember-me cookies
      @user.regenerate_session_token
      redirect_to signin_path, notice: 'Password updated! Please sign in with your new password.'
    else
      render :edit, status: :unprocessable_content
    end
  end

  private

  def set_user_from_token
    @token = params[:token].to_s
    @user = @token.present? ? User.find_by_token_for(:password_reset, @token) : nil

    return if @user

    redirect_to new_password_reset_path, alert: 'That reset link is invalid or has expired. Please request a new one.'
  end
end
