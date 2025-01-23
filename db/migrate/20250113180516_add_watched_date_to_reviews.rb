class AddWatchedDateToReviews < ActiveRecord::Migration[7.1]
  def change
    add_column :reviews, :watched_date, :date
  end
end
