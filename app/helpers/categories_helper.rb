module CategoriesHelper
  def category_icon(name)
    name_lower = name.downcase

    return 'lucide-user' if name_lower.include?('actor') || name_lower.include?('actress')
    return 'lucide-megaphone' if name_lower.include?('director')
    return 'lucide-pencil' if name_lower.include?('screenplay') || name_lower.include?('writing')
    return 'lucide-video' if name_lower.include?('cinematography')
    return 'lucide-scissors' if name_lower.include?('editing')
    if name_lower.include?('music') || name_lower.include?('score') || name_lower.include?('song')
      return 'lucide-music-4'
    end
    return 'lucide-volume-2' if name_lower.include?('sound')
    return 'lucide-brush' if name_lower.include?('design') || name_lower.include?('art')
    return 'lucide-sparkles' if name_lower.include?('visual') || name_lower.include?('effects')
    return 'lucide-palette' if name_lower.include?('makeup') || name_lower.include?('hair')
    return 'lucide-heart' if name_lower.include?('costume')
    return 'lucide-film' if name_lower.include?('picture') || name_lower.include?('film')
    return 'lucide-globe' if name_lower.include?('international') || name_lower.include?('foreign')
    return 'lucide-smile' if name_lower.include?('animated')
    return 'lucide-video' if name_lower.include?('documentary')
    return 'lucide-clock' if name_lower.include?('short')

    'lucide-award'
  end
end
