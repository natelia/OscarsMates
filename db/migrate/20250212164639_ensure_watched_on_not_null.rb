class EnsureWatchedOnNotNull < ActiveRecord::Migration[7.1]
  def up
    Review.where(watched_on: nil).update_all("watched_on = created_at")

    change_column_null :reviews, :watched_on, false
    add_index :reviews, :watched_on
  end

  def down
    remove_index :reviews, :watched_on
    change_column_null :reviews, :watched_on, true
  end
end
