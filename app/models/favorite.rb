# Represents a user's favorite movie association.
class Favorite < ApplicationRecord
  belongs_to :movie
  belongs_to :user
end
