class ChangeWatchedOnToDatetime < ActiveRecord::Migration[7.1]
  def up
    # Step 1: Add temporary datetime column
    add_column :reviews, :watched_on_temp, :datetime

    # Step 2: Migrate existing data with smart time assignment
    Review.find_each do |review|
      watched_date = review.watched_on
      created_datetime = review.created_at

      # If watched_on date matches created_at date, preserve the time
      if watched_date == created_datetime.to_date
        new_datetime = created_datetime.change(
          year: watched_date.year,
          month: watched_date.month,
          day: watched_date.day
        )
      else
        # Otherwise, default to midnight on that day
        new_datetime = watched_date.to_datetime  # Defaults to 00:00:00
      end

      review.update_column(:watched_on_temp, new_datetime)
    end

    # Step 3: Remove old column and rename temp column
    remove_index :reviews, :watched_on
    remove_column :reviews, :watched_on
    rename_column :reviews, :watched_on_temp, :watched_on

    # Step 4: Re-apply NOT NULL constraint and index
    change_column_null :reviews, :watched_on, false
    add_index :reviews, :watched_on
  end

  def down
    # Rollback: Convert datetime back to date
    add_column :reviews, :watched_on_temp, :date

    Review.find_each do |review|
      review.update_column(:watched_on_temp, review.watched_on.to_date)
    end

    remove_index :reviews, :watched_on
    remove_column :reviews, :watched_on
    rename_column :reviews, :watched_on_temp, :watched_on

    change_column_null :reviews, :watched_on, false
    add_index :reviews, :watched_on
  end
end
