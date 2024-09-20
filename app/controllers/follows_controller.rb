class FollowsController < ApplicationController
  before_action :find_user

  def create
    current_user.following << @user
    redirect_to @user, notice: 'You are now following this user.'
  end

  def destroy
    current_user.following.delete(@user)
    redirect_to @user, notice: 'You are no longer following this user.'
  end

  private

  def find_user
    @user = User.find(params[:id])
  end
end
