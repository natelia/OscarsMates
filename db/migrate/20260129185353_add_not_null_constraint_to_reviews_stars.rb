class AddNotNullConstraintToReviewsStars < ActiveRecord::Migration[7.1]
  def up
    # First, set any null stars to a default value (1) or delete those reviews
    Review.where(stars: nil).update_all(stars: 1)
    
    # Then add the NOT NULL constraint
    change_column_null :reviews, :stars, false
  end

  def down
    change_column_null :reviews, :stars, true
  end
end
