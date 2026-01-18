module UsersHelper
  # Generate a consistent color based on user name
  # Returns a hex color for avatars
  AVATAR_COLORS = [
    '#FF6B6B', # Coral
    '#4ECDC4', # Teal
    '#45B7D1', # Sky Blue
    '#96CEB4', # Sage
    '#FFEAA7', # Yellow
    '#DDA0DD', # Plum
    '#98D8C8', # Mint
    '#F7DC6F', # Gold
    '#BB8FCE', # Purple
    '#85C1E9'  # Light Blue
  ].freeze

  def avatar_color(name)
    return AVATAR_COLORS.first if name.blank?

    index = name.bytes.sum % AVATAR_COLORS.length
    AVATAR_COLORS[index]
  end

  def avatar_initials(name)
    return '?' if name.blank?

    name.split.map(&:first).first(2).join.upcase
  end

  def user_progress_for_year(user, year, total_movies)
    return 0 if total_movies.zero?

    watched = user.watched_movies_count_for_year(year)
    ((watched.to_f / total_movies) * 100).round(1)
  end

  def last_watched_movie(user, year)
    user.reviews_for_year(year)
        .order(created_at: :desc)
        .first
        &.movie
  end

  def rank_badge(rank)
    case rank
    when 1
      content_tag(:span, class: 'crown-animated') do
        content_tag(:i, '', class: 'bi bi-trophy-fill', style: 'color: #D4AF37; font-size: 1.5rem;')
      end
    when 2
      content_tag(:i, '', class: 'bi bi-award-fill', style: 'color: #C0C0C0; font-size: 1.25rem;')
    when 3
      content_tag(:i, '', class: 'bi bi-award-fill', style: 'color: #CD7F32; font-size: 1.25rem;')
    else
      content_tag(:span, "##{rank}", class: 'badge bg-secondary')
    end
  end
end
