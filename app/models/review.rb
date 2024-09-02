# Represents a review of a movie by a user.
class Review < ApplicationRecord
  belongs_to :movie
  belongs_to :user

  STARS = [1, 2, 3, 4, 5].freeze

  validates :stars, inclusion: {
    in: STARS,
    message: 'must be between 1 and 5'
  }
  validate :unique_user_review_for_movie

  private

  def unique_user_review_for_movie
    if Review.exists?(user_id: user_id, movie_id: movie_id)
      errors.add(:base, 'You have already reviewed this movie')
    end
  end
end
