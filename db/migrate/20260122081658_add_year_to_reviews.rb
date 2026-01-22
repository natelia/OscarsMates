class AddYearToReviews < ActiveRecord::Migration[7.1]
  def up
    add_column :reviews, :year, :integer

    # Backfill existing reviews with year from their movie's nomination
    execute <<-SQL
      UPDATE reviews
      SET year = (
        SELECT MIN(nominations.year)
        FROM nominations
        WHERE nominations.movie_id = reviews.movie_id
      )
      WHERE EXISTS (
        SELECT 1 FROM nominations WHERE nominations.movie_id = reviews.movie_id
      )
    SQL

    # Default to 2025 for reviews without nominations
    execute <<-SQL
      UPDATE reviews SET year = 2025 WHERE year IS NULL
    SQL

    change_column_null :reviews, :year, false
    add_index :reviews, %i[user_id movie_id year], unique: true
  end

  def down
    remove_index :reviews, %i[user_id movie_id year]
    remove_column :reviews, :year
  end
end
