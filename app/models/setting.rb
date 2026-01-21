class Setting < ApplicationRecord
  validates :year, presence: true, uniqueness: true
  validates :nomination_date, presence: true
  validates :ceremony_date, presence: true

  def self.for_year(year)
    find_or_initialize_by(year: year)
  end
end
