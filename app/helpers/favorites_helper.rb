module FavoritesHelper
  def fave_or_unfave_button(movie, favorite)
    if favorite
      button_to '♡ Unfave',
                movie_favorite_path(movie, favorite, year: current_year),
                method: :delete,
                class: 'inline-flex items-center rounded-md border border-rose-200 px-3 py-1.5 text-xs font-semibold text-rose-600 hover:bg-rose-50'
    else
      button_to '♥️Fave',
                movie_favorites_path(movie, year: current_year),
                class: 'inline-flex items-center rounded-md border border-rose-200 px-3 py-1.5 text-xs font-semibold text-rose-600 hover:bg-rose-50'
    end
  end
end
