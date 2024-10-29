class Nomination < ApplicationRecord
  belongs_to :movie
  belongs_to :category
end
