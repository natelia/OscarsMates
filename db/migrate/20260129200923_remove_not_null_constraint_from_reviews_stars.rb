class RemoveNotNullConstraintFromReviewsStars < ActiveRecord::Migration[7.1]
  def change
    change_column_null :reviews, :stars, true
  end
end
