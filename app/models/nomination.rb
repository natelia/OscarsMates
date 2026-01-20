class Nomination < ApplicationRecord
  belongs_to :movie
  belongs_to :category

  validates :year, presence: true,
                   numericality: { only_integer: true,
                                   greater_than_or_equal_to: 1929,
                                   less_than_or_equal_to: 2100 }
  validates :movie_id, uniqueness: { scope: %i[category_id year],
                                     message: 'already nominated in this category for this year' }

  scope :for_year, ->(year) { where(year: year) }

  def self.available_years
    distinct.order(year: :desc).pluck(:year)
  end
end
