class UserFilterService
  def initialize(current_user, filter)
    @current_user = current_user
    @filter = filter
  end

  def call
    if @filter == 'all' || !@current_user
      User.all
    else
      @current_user.following
    end
  end
end
