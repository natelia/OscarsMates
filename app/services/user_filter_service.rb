class UserFilterService
  def initialize(current_user, filter)
    @current_user = current_user
    @filter = filter
  end

  def call
    if @filter == 'followed' && @current_user
      @current_user.following
    else
      User.all
    end
  end
end
