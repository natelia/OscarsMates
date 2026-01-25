class Category < ApplicationRecord
  has_many :nominations, dependent: :destroy
  has_many :movies, through: :nominations
  has_many :user_picks, dependent: :destroy
  validates :name, presence: true

  scope :for_year, lambda { |year|
    joins(:nominations).where(nominations: { year: year }).distinct
  }
end
