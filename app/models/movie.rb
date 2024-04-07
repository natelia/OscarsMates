class Movie < ApplicationRecord
  has_many :reviews
  
  validates :title, presence: true
  validates :english_title, presence: true
  validates :where_to_watch, presence: true
  validates :runtime, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :rating, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }
  validates :url, presence: true
  validates :picture_url, presence: true
end
