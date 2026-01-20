module ApplicationHelper
  def current_user
    User.find(session[:user_id]) if session[:user_id]
  end

  def watch_or_unwatch_button(movie, review)
    if review
      link_to 'Unwatch', movie_review_path(movie, review, year: current_year),
              method: :delete,
              data: { turbo_method: :delete, turbo_confirm: 'Are you sure?' },
              class: 'inline-flex items-center rounded-md border border-[#56020233] px-3 py-1.5 text-xs font-semibold text-[#560202] hover:bg-[#F0E5E5]'
    else
      link_to 'Watched!', new_movie_review_path(movie, year: current_year),
              class: 'inline-flex items-center rounded-md border border-[#02552233] px-3 py-1.5 text-xs font-semibold text-[#025522] hover:bg-[#F0FDF4]'
    end
  end
end
