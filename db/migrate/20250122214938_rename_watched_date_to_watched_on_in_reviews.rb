class RenameWatchedDateToWatchedOnInReviews < ActiveRecord::Migration[7.1]
  def change
    rename_column :reviews, :watched_date, :watched_on
  end
end
