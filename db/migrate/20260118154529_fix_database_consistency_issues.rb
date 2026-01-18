class FixDatabaseConsistencyIssues < ActiveRecord::Migration[7.1]
  def change
    # Fix NOT NULL constraints for users table
    change_column_null :users, :name, false
    change_column_null :users, :email, false
    change_column_null :users, :admin, false

    # Fix NOT NULL constraints for movies table
    change_column_null :movies, :title, false
    change_column_null :movies, :english_title, false
    change_column_null :movies, :where_to_watch, false
    change_column_null :movies, :runtime, false
    change_column_null :movies, :rating, false
    change_column_null :movies, :url, false
    change_column_null :movies, :picture_url, false

    # Fix NOT NULL constraints for other tables
    change_column_null :genres, :name, false
    change_column_null :categories, :name, false
    change_column_null :follows, :follower_id, false
    change_column_null :follows, :followed_id, false
    change_column_null :reviews, :user_id, false

    # Add missing indexes
    add_index :reviews, :user_id, if_not_exists: true
    add_index :follows, :followed_id, if_not_exists: true

    # Add missing unique indexes
    add_index :users, 'LOWER(email)', unique: true, name: 'index_users_on_lower_email'
    add_index :movies, :title, unique: true, if_not_exists: true
    add_index :genres, :name, unique: true, if_not_exists: true

    # Add missing foreign keys
    add_foreign_key :reviews, :users, if_not_exists: true
    add_foreign_key :follows, :users, column: :follower_id, if_not_exists: true
    add_foreign_key :follows, :users, column: :followed_id, if_not_exists: true

    # Remove redundant index (covered by index_nominations_on_year_and_movie_id)
    remove_index :nominations, :year, if_exists: true
  end
end
