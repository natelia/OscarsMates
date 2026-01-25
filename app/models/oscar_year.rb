# Represents an Oscar ceremony year with announcement and ceremony dates.
class OscarYear < ApplicationRecord
  has_many :nominations, dependent: :destroy
  has_many :reviews, dependent: :destroy
end
