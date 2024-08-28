# Represents a movie in the application
class Movie < ApplicationRecord
  before_save :set_slug
  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :fans, through: :favorites, source: :user
  has_many :characterizations, dependent: :destroy
  has_many :genres, through: :characterizations
  has_many :nominations, dependent: :destroy
  has_many :categories, through: :nominations
  has_many :watcheds, dependent: :destroy

  validates :title, presence: true, uniqueness: true
  validates :english_title, presence: true
  validates :where_to_watch, presence: true
  validates :runtime, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :rating, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }
  validates :url, presence: true
  validates :picture_url, presence: true

  def average_stars
    reviews.average(:stars) || 0.0
  end

  def to_param
    slug
  end

  private

  def set_slug
    self.slug = title.parameterize
  end
end
