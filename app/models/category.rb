class Category < ApplicationRecord
  has_many :nominations, dependent: :destroy
  has_many :movies, through: :nominations

  validates :name, presence: true, uniqueness: true

  scope :for_year, lambda { |year|
    joins(:nominations).where(nominations: { year: year }).distinct
  }
end
