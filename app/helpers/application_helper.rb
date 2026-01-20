module ApplicationHelper
  def current_user
    User.find(session[:user_id]) if session[:user_id]
  end

  def watch_or_unwatch_button(movie, review)
    if review
      link_to 'Unwatch', movie_review_path(movie, review, year: current_year),
              method: :delete,
              data: { turbo_method: :delete, turbo_confirm: 'Are you sure?' },
              class: 'inline-flex items-center rounded-md border border-red-200 px-3 py-1.5 text-xs font-semibold text-red-600 hover:bg-red-50'
    else
      link_to 'Watched!', new_movie_review_path(movie, year: current_year),
              class: 'inline-flex items-center rounded-md border border-emerald-200 px-3 py-1.5 text-xs font-semibold text-emerald-700 hover:bg-emerald-50'
    end
  end
end
