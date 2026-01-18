module CategoriesHelper
  def category_icon(name)
    name_lower = name.downcase

    return 'bi-person-fill' if name_lower.include?('actor') || name_lower.include?('actress')
    return 'bi-megaphone-fill' if name_lower.include?('director')
    return 'bi-pencil-fill' if name_lower.include?('screenplay') || name_lower.include?('writing')
    return 'bi-camera-reels-fill' if name_lower.include?('cinematography')
    return 'bi-scissors' if name_lower.include?('editing')
    if name_lower.include?('music') || name_lower.include?('score') || name_lower.include?('song')
      return 'bi-music-note-beamed'
    end
    return 'bi-volume-up-fill' if name_lower.include?('sound')
    return 'bi-brush-fill' if name_lower.include?('design') || name_lower.include?('art')
    return 'bi-stars' if name_lower.include?('visual') || name_lower.include?('effects')
    return 'bi-palette-fill' if name_lower.include?('makeup') || name_lower.include?('hair')
    return 'bi-suit-heart-fill' if name_lower.include?('costume')
    return 'bi-film' if name_lower.include?('picture') || name_lower.include?('film')
    return 'bi-globe' if name_lower.include?('international') || name_lower.include?('foreign')
    return 'bi-emoji-smile' if name_lower.include?('animated')
    return 'bi-camera-video-fill' if name_lower.include?('documentary')
    return 'bi-clock-fill' if name_lower.include?('short')

    'bi-award-fill'
  end
end
