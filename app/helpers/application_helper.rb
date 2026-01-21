module ApplicationHelper
  def current_user
    User.find(session[:user_id]) if session[:user_id]
  end

  def watch_or_unwatch_button(movie, review)
    if review
      link_to 'Unwatch', movie_review_path(movie, review, year: current_year),
              method: :delete,
              data: { turbo_method: :delete, turbo_confirm: 'Are you sure?' },
              class: 'btn-unwatch inline-flex items-center rounded-md border px-3 py-1.5 text-xs font-semibold'
    else
      link_to 'Watched!', new_movie_review_path(movie, year: current_year),
              class: 'btn-watched inline-flex items-center rounded-md border px-3 py-1.5 text-xs font-semibold'
    end
  end
end
