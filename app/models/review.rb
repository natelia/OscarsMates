# Represents a review of a movie by a user.
class Review < ApplicationRecord
  belongs_to :movie
  belongs_to :user

  STARS = (1..10).to_a.freeze

  validates :stars, inclusion: { in: STARS, message: 'must be between 1 and 10' }
  validates :watched_on, presence: true
  validates :user_id, uniqueness: { scope: :movie_id, message: 'has already reviewed this movie' }
end
