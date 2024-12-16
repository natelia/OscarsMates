module MoviesHelper
  def average_stars(movie)
    if movie.average_stars.zero?
      content_tag(:strong, 'No reviews')
    else
      pluralize(number_with_precision(movie.average_stars, precision: 1), 'star')
    end
  end

  def watch_or_unwatch_button(movie, review)
    if review
      button_to 'Unwatch! ', movie_review_path(movie, review), method: :delete, class: 'btn btn-outline-warning btn-sm'
    else
      link_to 'Watched!', new_movie_review_path(movie), class: 'btn btn-outline-primary btn-sm'
    end
  end
end
