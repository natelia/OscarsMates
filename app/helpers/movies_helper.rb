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
                class: 'btn-unwatch inline-flex items-center rounded-md border px-3 py-1.5 text-xs font-semibold'
    else
      link_to 'Watched!',
              new_movie_review_path(movie, year: current_year),
              class: 'btn-watched inline-flex items-center rounded-md border px-3 py-1.5 text-xs font-semibold'
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
      'My rating'
    when 'imdb_rating'
      'IMDB rating'
    when 'duration'
      'Longest'
    when 'shortest'
      'Shortest'
    when 'watched_by_mates'
      "Mates' rating"
    when 'most_watched_by_mates'
      'Most watched'
    when 'most_nominated'
      'Nominations'
    else
      'A-Z'
    end
  end
end
