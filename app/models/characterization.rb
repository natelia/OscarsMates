class Characterization < ApplicationRecord
  belongs_to :movie
  belongs_to :genre

  validates :movie_id, uniqueness: { scope: :genre_id, message: 'already has this genre' }
end
