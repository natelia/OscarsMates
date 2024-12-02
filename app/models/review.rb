# Represents a review of a movie by a user.
class Review < ApplicationRecord
  belongs_to :movie
  belongs_to :user

  STARS = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].freeze

  validates :stars, inclusion: {
    in: STARS,
    message: 'must be between 1 and 10'
  }
  validate :unique_user_review_for_movie

  private

  def unique_user_review_for_movie
    if Review.exists?(user_id: user_id, movie_id: movie_id)
      errors.add(:base, 'You have already reviewed this movie')
    end
  end
end
