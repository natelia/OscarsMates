module ApplicationHelper
  def current_user
    User.find(session[:user_id]) if session[:user_id]
  end

  def watch_or_unwatch_button(movie, review)
    if review
<<<<<<< HEAD
      unwatch_button(movie, review)
    else
      watch_button(movie)
    end
  end

  private

  def unwatch_button(movie, review)
    link_to "Unwatch", movie_review_path(movie, review),
            method: :delete,
            data: { turbo_method: :delete, turbo_confirm: "Are you sure?" },
            class: "btn btn-outline-danger btn-sm"
  end

  def watch_button(movie)
    link_to "Watched!", new_movie_review_path(movie),
            class: "btn btn-outline-primary btn-sm"
  end
=======
      link_to "Unwatch", movie_review_path(movie, review), 
              method: :delete, 
              data: { turbo_method: :delete, turbo_confirm: "Are you sure?" }, 
              class: "btn btn-outline-danger btn-sm"
    else
      link_to "Watched!", new_movie_review_path(movie), class: "btn btn-outline-primary btn-sm"
    end
  end


>>>>>>> origin/main
end
