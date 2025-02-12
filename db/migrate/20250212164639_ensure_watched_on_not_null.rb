class EnsureWatchedOnNotNull < ActiveRecord::Migration[7.1]
  def up
    Review.where(watched_on: nil).update_all("watched_on = created_at")

    change_column_null :reviews, :watched_on, false

  def down
    change_column_null :reviews, :watched_on, true
  end
  end
end
