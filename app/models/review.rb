# Represents a review of a movie by a user.
class Review < ApplicationRecord
  belongs_to :movie
  belongs_to :user

  STARS = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].freeze

  validates :stars, inclusion: { in: STARS, message: 'must be between 1 and 10' }
  validates :watched_on, presence: true
  validates :year, presence: true
  validate :unique_user_review_for_movie_and_year
  validate :movie_nominated_in_year

  scope :for_year, ->(year) { where(year: year) }

  private

  def unique_user_review_for_movie_and_year
    return unless Review.exists?(user_id: user_id, movie_id: movie_id, year: year)

    errors.add(:base, 'You have already reviewed this movie for this year')
  end

  def movie_nominated_in_year
    return if movie&.nominations&.exists?(year: year)

    errors.add(:movie, "is not nominated in #{year}")
  end
end
