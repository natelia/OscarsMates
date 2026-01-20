# Represents a user's favorite movie association.
class Favorite < ApplicationRecord
  belongs_to :movie
  belongs_to :user

  validates :user_id, uniqueness: { scope: :movie_id, message: 'has already favorited this movie' }
end
