class Category < ApplicationRecord
  has_many :nominations, dependent: :destroy
  has_many :movies, through: :nominations
  
  validates :name, presence: true
end
