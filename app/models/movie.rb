class Movie < ApplicationRecord

  def self.released
    Movie.where("released_on < ?", Time.now).order("released_on desc")
  end

  validates :title, presence: true
  validates :english_title, presence: true
  validates :where_to_watch, presence: true
  validates :runtime, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :rating, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }
  validates :url, presence: true
  validates :picture_url, presence: true
  validates :released_on, presence: true
end
