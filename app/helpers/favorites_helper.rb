module FavoritesHelper
  def fave_or_unfave_button(movie, favorite)
    if favorite
      button_to '♡ Unfave', movie_favorite_path(movie, favorite, year: current_year), method: :delete
    else
      button_to '♥️Fave', movie_favorites_path(movie, year: current_year)
    end
  end
end
