class AddFieldsToMovies < ActiveRecord::Migration[7.1]
  def change
    add_column :movies, :released_on, :date
  end
end
