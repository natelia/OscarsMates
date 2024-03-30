class Movie < ApplicationRecord



  validates :title, :english_title, :where_to_watch, :released_on, presence: true
  validates :runtime, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :rating, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }
  validates :url, presence: true
  validates :picture_url, presence: true
end
