# Represents a user of the application.
class User < ApplicationRecord
  # Generates a random 4-digit PIN before a user is created
  before_create :generate_pin

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
                    format: { with: /\S+@\S+/ },
                    uniqueness: { case_sensitive: false }

  private

  def generate_pin
    self.pin = rand(1000...9999)
  end

end
