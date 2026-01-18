# Represents a user of the application.
class User < ApplicationRecord
  has_secure_password

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

  def reviews_for_year(year)
    reviews.joins(movie: :nominations)
           .where(nominations: { year: year })
           .distinct
  end

  def watched_movies_count_for_year(year)
    reviews_for_year(year).select(:movie_id).distinct.count
  end
end
