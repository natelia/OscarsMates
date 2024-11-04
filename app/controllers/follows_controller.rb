class FollowsController < ApplicationController
  before_action :require_signin
  before_action :find_user

  def create
    current_user.following << @user
     redirect_back fallback_location: users_path, notice: "You are now following  #{@user.name}."
  end

  def destroy
    current_user.following.delete(@user)
    redirect_back fallback_location: users_path, notice: "You are no longer following #{@user.name}."
  end

  private

  def find_user
    @user = User.find(params[:id])
  end
end
