class UserPick < ApplicationRecord
  belongs_to :user
  belongs_to :category
  belongs_to :movie

  validates :year, presence: true
  validates :user_id,
            uniqueness: { scope: %i[category_id year],
                          message: 'can only pick one movie per category per year' }
  validate :movie_must_be_nominated_in_category

  private

  def movie_must_be_nominated_in_category
    return if movie.blank? || category.blank? || year.blank?
    return if Nomination.exists?(movie_id: movie_id, category_id: category_id, year: year)

    errors.add(:movie, 'must be nominated in this category for this year')
  end
end
