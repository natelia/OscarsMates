module FavoritesHelper
  def fave_or_unfave_button(movie, favorite)
    button_class = 'inline-flex items-center rounded-md border border-[#56020233] ' \
                   'px-3 py-1.5 text-xs font-semibold text-[#560202] hover:bg-[#F0E5E5]'

    if favorite
      button_to '♡ Unfave',
                movie_favorite_path(movie, favorite, year: current_year),
                method: :delete,
                class: button_class
    else
      button_to '♥️Fave',
                movie_favorites_path(movie, year: current_year),
                class: button_class
    end
  end
end
