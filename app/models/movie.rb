# Represents a movie in the application
class Movie < ApplicationRecord
  STREAMING_SERVICES = [
    'Netflix',
    'Amazon Prime Video',
    'Max',
    'Disney+',
    'Apple TV+',
    'Hulu',
    'Paramount+',
    'Peacock',
    'YouTube',
    'VOD',
    'CinemaCity',
    'Multikino'
  ].freeze

  before_save :set_slug
  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :fans, through: :favorites, source: :user
  has_many :characterizations, dependent: :destroy
  has_many :genres, through: :characterizations
  has_many :nominations, dependent: :destroy
  has_many :categories, through: :nominations
  has_many :user_picks, dependent: :destroy

  validates :title, presence: true, uniqueness: true
  validates :english_title, presence: true
  validates :where_to_watch, presence: true
  validates :runtime, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :rating, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }
  validates :url, presence: true
  validates :picture_url, presence: true

  scope :for_year, lambda { |year|
    joins(:nominations).where(nominations: { year: year }).distinct
  }

  def self.available_years
    Nomination.available_years
  end

  def average_stars
    reviews.average(:stars) || 0.0
  end

  def mates_average_stars(user)
    return 0.0 unless user

    mate_ids = user.following.pluck(:id)
    return 0.0 if mate_ids.empty?

    reviews.where(user_id: mate_ids).average(:stars) || 0.0
  end

  def to_param
    slug
  end

  def streaming_services_array
    where_to_watch.to_s.split(',').map(&:strip).compact_blank
  end

  def streaming_services_array=(services)
    self.where_to_watch = services.compact_blank.join(', ')
  end

  def self.streaming_service_url(service)
    {
      'Netflix' => 'https://www.netflix.com',
      'Amazon Prime Video' => 'https://www.primevideo.com',
      'Max' => 'https://www.max.com',
      'Disney+' => 'https://www.disneyplus.com',
      'Apple TV+' => 'https://tv.apple.com',
      'Hulu' => 'https://www.hulu.com',
      'Paramount+' => 'https://www.paramountplus.com',
      'Peacock' => 'https://www.peacocktv.com',
      'YouTube' => 'https://www.youtube.com',
      'VOD' => nil,
      'CinemaCity' => 'https://www.cinema-city.pl',
      'Multikino' => 'https://www.multikino.pl'
    }[service]
  end

  private

  def set_slug
    self.slug = title.parameterize
  end
end
