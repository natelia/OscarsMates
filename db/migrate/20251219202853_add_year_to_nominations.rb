class AddYearToNominations < ActiveRecord::Migration[7.1]
  def change
    add_column :nominations, :year, :integer, null: false, default: 2025
    add_index :nominations, :year
    add_index :nominations, [:year, :category_id]
    add_index :nominations, [:year, :movie_id]
  end
end
