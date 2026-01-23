# Represents a user of the application.
class User < ApplicationRecord
  has_secure_password
  has_one_attached :avatar

  AVATAR_CONTENT_TYPES = %w[image/png image/jpeg image/gif image/webp].freeze
  AVATAR_MAX_SIZE = 5.megabytes

  # User relationships
  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_movies, through: :favorites, source: :movie

  # Users that the current user is following
  has_many :follows, foreign_key: :follower_id, dependent: :destroy
  has_many :following, through: :follows, source: :followed
  # Users that follow the current user
  has_many :inverse_follows, class_name: 'Follow', foreign_key: :followed_id, dependent: :destroy
  has_many :followers, through: :inverse_follows, source: :follower

  validates :name, presence: true
  validates :email, presence: true,
                    format: { with: /\A\S+@\S+\z/ },
                    uniqueness: { case_sensitive: false }
  validate :acceptable_avatar

  def reviews_for_year(year)
    reviews.joins(movie: :nominations)
           .where(nominations: { year: year })
           .distinct
  end

  def watched_movies_count_for_year(year)
    reviews_for_year(year).select(:movie_id).distinct.count
  end

  def initials
    name.split.map(&:first).join.upcase[0, 2]
  end

  private

  def acceptable_avatar
    return unless avatar.attached?

    errors.add(:avatar, 'must be PNG, JPEG, GIF, or WebP') unless avatar.blob.content_type.in?(AVATAR_CONTENT_TYPES)
    errors.add(:avatar, 'must be less than 5MB') if avatar.blob.byte_size > AVATAR_MAX_SIZE
  end
end
