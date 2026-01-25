class Nomination < ApplicationRecord
  belongs_to :movie
  belongs_to :category

  # Alias year to oscar_year_id for backwards compatibility
  alias_attribute :year, :oscar_year_id

  validates :oscar_year_id, presence: true,
                            numericality: { only_integer: true,
                                            greater_than_or_equal_to: 1929,
                                            less_than_or_equal_to: 2100 }

  scope :for_year, ->(year) { where(oscar_year_id: year) }

  def self.available_years
    distinct.order(oscar_year_id: :desc).pluck(:oscar_year_id)
  end
end
