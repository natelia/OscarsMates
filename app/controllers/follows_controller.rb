class FollowsController < ApplicationController
  before_action :require_signin
  before_action :find_user

  def create
    if current_user.following.include?(@user)
      redirect_back_or_to(users_path, alert: "You are already following #{@user.name}.")
    else
      current_user.following << @user
      redirect_back_or_to(users_path, notice: "#{@user.name} has become your mate.")
    end
  end

  def destroy
    current_user.following.delete(@user)
    redirect_back_or_to(users_path, notice: "You are no longer following #{@user.name}.")
  end

  private

  def find_user
    @user = User.find(params.expect(:id))
  end
end
