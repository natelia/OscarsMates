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
      button_to 'Unwatch! ',
                movie_review_path(movie, review, year: current_year),
                method: :delete,
                class: 'inline-flex items-center rounded-md border border-red-200 px-3 py-1.5 text-xs font-semibold text-red-600 hover:bg-red-50'
    else
      link_to 'Watched!',
              new_movie_review_path(movie, year: current_year),
              class: 'inline-flex items-center rounded-md border border-emerald-200 px-3 py-1.5 text-xs font-semibold text-emerald-700 hover:bg-emerald-50'
    end
  end

  def filter_label(filter_by)
    case filter_by
    when 'unwatched'
      'Unwatched'
    when 'watched'
      'Watched'
    else
      'All'
    end
  end

  def sort_label(sort_by)
    case sort_by
    when 'my_rating'
      'My Rating'
    when 'imdb_rating'
      'IMDB'
    when 'duration'
      'Longest'
    when 'shortest'
      'Shortest'
    when 'watched_by_mates'
      'Mates'
    when 'most_nominated'
      'Nominations'
    else
      'A-Z'
    end
  end
end
